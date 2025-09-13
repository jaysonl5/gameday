class ExternalPaymentSyncService
  def self.sync
    new.sync
  end

  def sync
    oauth_token = OauthTokenService.fetch_token
    response = oauth_token.get(ENV['MX_SYNC_URL'])

    oauth_data = if response.code.to_i == 200
      Rails.logger.info("OAuth Response: #{response.body}")
      { success: true, data: JSON.parse(response.body) }
    else
      Rails.logger.error("OAuth Error: #{response.body}")
      { success: false, error: response.body }
    end
    return {status: "error", message: "Failed to fetch OAuth data"} unless oauth_data[:success]
    payment_data = fetch_payment_data(oauth_data)
    Rails.logger.info("Payment Records Count: #{payment_data&.length}")  # Log number of records

    
    save_payments(payment_data)
    {status: "success", message: "Payments data fetched successfully"}
  rescue StandardError=> e
    Rails.logger.error("Error fetching payments data: #{e.message}")
    {status: "error", message: "Error fetching payments data"}
  end

  private

  def fetch_payment_data(oauth_data)
    Rails.logger.info("Fetching payment data")
    return [] unless oauth_data&.dig(:data, "records")

    oauth_data[:data]["records"]
  rescue StandardError => e
    Rails.logger.error("Error fetching payment data: #{e.message}")
    raise "Failed to fetch payment data: #{e.message}"
  end

  def save_payments(payment_records)
    return if payment_records.empty?

    processed_count = 0
    failed_payments = []

    payment_records.each do |payment_record|
      begin
        save_single_payment(payment_record)
        processed_count += 1
      rescue StandardError => e
        failed_payments << {id: payment_record["id"], error: e.message}
        Rails.logger.error("Error saving payment #{payment_record["id"]}: #{e.message}")
      end
    end

    log_results(processed_count, failed_payments)
  end

  def save_single_payment(payment_record)
    
    
    Rails.logger.info "Processing payment with id: #{payment_record["id"]}"

    current_invoice_no = payment_record["invoice"]
    existing_rejected_recurring_payment = Payment.declined.recurring.where(invoice: current_invoice_no).where.not(api_id: payment_record["id"]).first
    existing_approved_recurring_payment = Payment.approved.recurring.where(invoice: current_invoice_no).where.not(api_id: payment_record["id"]).first
    existing_voided_recurring_payment = Payment.voided.recurring.where(invoice: current_invoice_no).where.not(api_id: payment_record["id"]).first

    if payment_record["id"].present?
      Payment.find_or_initialize_by(api_id: payment_record["id"]).tap do |payment|
          if payment.new_record?
            payment.api_id = payment_record["id"]
          end
          payment.created_at_api = Time.parse(payment_record["created"])
          payment.creator_name = payment_record["creatorName"]
          payment.is_duplicate = payment_record["isDuplicate"]
          payment.merchant_id = payment_record["merchantId"]
          payment.tender_type = payment_record["tenderType"]
          payment.currency = payment_record["currency"]
          payment.amount = payment_record["amount"].to_d
          payment.card_type = payment_record["cardAccount"]&.[]("cardType")
          payment.card_last4 = payment_record["cardAccount"]&.[]("cardLast4")
          payment.customer_id = payment_record["customer"]&.[]("id")
          payment.auth_only = payment_record["authOnly"]
          payment.auth_code = payment_record["authCode"]
          payment.status = payment_record["status"]
          payment.avs_account_name_match_performed = payment_record["risk"]&.[]("avsAccountNameMatchPerformed")
          payment.settled_amount = payment_record["settledAmount"].to_d
          payment.settled_currency = payment_record["settledCurrency"]
          payment.auth_message = payment_record["authMessage"]
          payment.available_auth_amount = payment_record["availableAuthAmount"].to_d
          payment.reference = payment_record["reference"]
          payment.tax = payment_record["tax"].to_d
          payment.surcharge_amount = payment_record["surchargeAmount"].to_d
          payment.surcharge_rate = payment_record["surchargeRate"].to_d
          payment.surcharge_label = payment_record["surchargeLabel"]
          payment.invoice = payment_record["invoice"]
          payment.client_reference = payment_record["clientReference"]
          payment.payment_type = payment_record["type"]
          payment.review_indicator = payment_record["reviewIndicator"]
          payment.should_get_credit_card_level = payment_record["shouldGetCreditCardLevel"]
          payment.response_code = payment_record["responseCode"]
          payment.issuer_response_code = payment_record["IssuerResponseCode"]
          payment.source = existing_rejected_recurring_payment ? "Recurring" : payment_record["source"]
          if existing_rejected_recurring_payment
            payment.source = "Recurring"
            Rails.logger.info "Updated Payment #{payment.id} to Recurring since it has a declined recurring payment with the same invoice number"
          elsif existing_approved_recurring_payment
            if payment_record["payment_type"] == 'Return' 
              payment.source = "Recurring"
              Rails.logger.info "Updated Payment #{payment.id} to Recurring since it is a return for a recurring payment with the same invoice number"
            end
          elsif existing_voided_recurring_payment
            payment.source = "Recurring"
            Rails.logger.info "Updated Payment #{payment.id} to Recurring since there is a voided recurring payment with the same invoice number"
          else
            Rails.logger.info "No other recurring payments found for invoice number #{current_invoice_no}"
          end
          
          # Set recurring boolean field based on source
          payment.recurring = (payment.source == 'Recurring')
          
          Rails.logger.info "Payment #{payment.id} saving"
          payment.save!
      end
    end
  end

  def log_results(processed_count, failed_payments)
    Rails.logger.info(
      "Payment sync completed: #{processed_count} processed, #{failed_payments.size} failed"
    )
    
    Rails.logger.error("Failed payments: #{failed_payments}") if failed_payments.any?
  end
end 