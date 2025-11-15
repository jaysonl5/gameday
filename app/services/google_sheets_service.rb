require 'google/apis/sheets_v4'
require 'googleauth'

class GoogleSheetsService
  include Google::Apis::SheetsV4
  
  def initialize
    @service = Google::Apis::SheetsV4::SheetsService.new
    @service.client_options.application_name = 'Gameday Patient Census'
    @service.authorization = authorize
    @spreadsheet_id = ENV['GOOGLE_SHEET_ID']
  end

  def sync_patient_census_entry(entry)
    return false unless @spreadsheet_id.present?
    
    begin
      case entry.patient_result
      when 'Win'
        puts(format_win_data(entry)) # Debugging line to check data format
        append_to_sheet(ENV['GOOGLE_SHEET_WINS_TAB'], format_win_data(entry))
      when 'Thinker'
        puts(format_thinker_data(entry)) # Debugging line to check data format
        append_to_sheet(ENV['GOOGLE_SHEET_THINKERS_TAB'], format_thinker_data(entry))
      when 'Loss'
        puts(format_loss_data(entry)) # Debugging line to check data format
        append_to_sheet(ENV['GOOGLE_SHEET_LOSS_TAB'], format_loss_data(entry))
      end
      
      Rails.logger.info "Successfully synced patient census entry #{entry.id} to Google Sheets"
      true
    rescue Google::Apis::Error => e
      Rails.logger.error "Google Sheets API error for entry #{entry.id}: #{e.message}"
      false
    rescue StandardError => e
      Rails.logger.error "Unexpected error syncing entry #{entry.id} to Google Sheets: #{e.message}"
      false
    end
  end

  private

  def authorize
    Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: StringIO.new({
        type: 'service_account',
        project_id: ENV['GOOGLE_PROJECT_ID'],
        private_key: ENV['GOOGLE_PRIVATE_KEY']&.gsub('\n', "\n"),
        client_email: ENV['GOOGLE_CLIENT_EMAIL'],
        auth_uri: 'https://accounts.google.com/o/oauth2/auth',
        token_uri: 'https://oauth2.googleapis.com/token',
        auth_provider_x509_cert_url: 'https://www.googleapis.com/oauth2/v1/certs'
      }.to_json),
      scope: Google::Apis::SheetsV4::AUTH_SPREADSHEETS
    )
  end

  def append_to_sheet(tab_name, data)
    # Use a specific range starting from column A to ensure proper alignment
    range = "#{tab_name}!A:A"
    value_range = Google::Apis::SheetsV4::ValueRange.new(values: [data])
    
    @service.append_spreadsheet_value(
      @spreadsheet_id,
      range,
      value_range,
      value_input_option: 'USER_ENTERED',
      insert_data_option: 'INSERT_ROWS'
    )
  end

  def format_win_data(entry)
    [
      format_date(entry.date),
      entry.patient_name,
      normalize_mail_out_clinic(entry.mail_out_in_clinic),
      entry.in_clinic_dose_ml,
      normalize_yes_no_na(entry.med_order_made),
      normalize_yes_no_na(entry.lab_call_scheduled),
      normalize_monthly_contract(entry.monthly_contract_made),
      normalize_annual_lab_contract(entry.annual_lab_contract),
      normalize_yes_no(entry.consents_signed),
      normalize_clinic_appt(entry.in_clinic_appt_made),
      normalize_yes_no_na(entry.mail_out_appt_made),
      entry.notes,
      normalize_lead_source(entry.lead_source),
      format_plan_for_sheets(entry.plan),
      entry.plan_notes,
      normalize_rate(entry.rate),
      entry.extra_info
    ]
  end

  def format_thinker_data(entry)
    [
      format_date(entry.date),
      entry.patient_name,
      entry.p_or_other,
      format_plan_for_sheets(entry.plan),
      normalize_rate(entry.rate),
      entry.extra_info,
      entry.phone_number,
      entry.notes
    ]
  end

  def format_loss_data(entry)
    [
      format_date(entry.date),
      entry.patient_name,
      entry.p_or_other,
      format_plan_for_sheets(entry.plan),
      entry.why_a_loss
    ]
  end

  def format_plan_array(plan)
    return '' if plan.blank?
    plan.is_a?(Array) ? plan.join(', ') : plan.to_s
  end

  # Normalize Mail Out/In Clinic values
  def normalize_mail_out_clinic(value)
    case value&.to_s&.downcase
    when 'in clinic', 'in_clinic', 'clinic'
      'In Clinic'
    when 'mail out', 'mail_out', 'mailout'
      'Mail Out'
    else
      value.presence || ''
    end
  end

  # Normalize Yes/No/NA dropdown values
  def normalize_yes_no_na(value)
    case value&.to_s&.downcase
    when 'yes', 'y', 'true'
      'Yes'
    when 'no', 'n', 'false'
      'No'
    when 'na', 'n/a', 'not applicable'
      'NA'
    else
      value.presence || ''
    end
  end

  # Normalize Consents Signed dropdown values (has more options than basic Yes/No)
  def normalize_yes_no(value)
    case value&.to_s
    when 'NA'
      'NA'
    when 'Yes'
      'Yes'
    when 'No'
      'No'
    when 'OTHER-check Chrono'
      'OTHER-check Chrono'
    when 'Sent Consent'
      'Sent Consent'
    else
      value.presence || ''
    end
  end

  # Normalize Monthly Contract Made (has more options)
  def normalize_monthly_contract(value)
    case value&.to_s
    when 'Yes'
      'Yes'
    when 'No'
      'No'
    when 'OTHER-check Chrono'
      'OTHER-check Chrono'
    when 'Contract made on PP'
      'Contract made on PP'
    else
      value.presence || ''
    end
  end

  # Normalize Annual Lab Contract
  def normalize_annual_lab_contract(value)
    case value&.to_s
    when 'Yes'
      'Yes'
    when 'No'
      'No'
    when 'OTHER-check Chrono'
      'OTHER-check Chrono'
    else
      value.presence || ''
    end
  end

  # Normalize In Clinic Appt Made
  def normalize_clinic_appt(value)
    case value&.to_s
    when 'Yes'
      'Yes'
    when 'No'
      'No'
    when 'OTHER-check Chrono'
      'OTHER-check Chrono'
    else
      value.presence || ''
    end
  end

  # Normalize Lead Source values
  def normalize_lead_source(value)
    valid_sources = [
      'Paradigm', 'Google', 'Referral', 'GD Web', 'FB/Insta',
      'Other See Notes', 'Clinic Transfer', 'Ground Marketing',
      'No Answer', 'Staff Referrals', 'TiffOKC', 'BigTre'
    ]
    
    # Find exact match first
    return value if valid_sources.include?(value)
    
    # Try case-insensitive match
    matched = valid_sources.find { |source| source.downcase == value&.downcase }
    matched || value.presence || ''
  end

  # Enhanced plan formatting for sheets
  def format_plan_for_sheets(plan)
    return '' if plan.blank?
    
    valid_plans = [
      'TRT', 'Enclomiphene', 'Peptides', 'Semaglutide', 'Tirzepatide',
      'Gainswave', 'P-Shot', 'Trimix', 'Gonadorelin', 'Clomid',
      'Pellets', 'Vitamin Package', 'Peptide Bundle', 'Other SEE notes'
    ]
    
    plan_array = plan.is_a?(Array) ? plan : [plan.to_s]
    
    # Validate and normalize each plan item
    normalized_plans = plan_array.map do |item|
      matched = valid_plans.find { |valid| valid.downcase == item&.downcase }
      matched || item
    end.compact
    
    normalized_plans.join(', ')
  end

  # Normalize rate field
  def normalize_rate(value)
    return value if value.is_a?(Numeric)
    return '' if value.blank?
    
    # Handle string numbers
    value.to_s.strip
  end

  # Ensure consistent date formatting
  def format_date(date)
    return '' if date.blank?
    
    case date
    when Date, Time, DateTime
      date.strftime('%Y-%m-%d')
    else
      date.to_s
    end
  end
end