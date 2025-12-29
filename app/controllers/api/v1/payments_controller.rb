module Api
  module V1
    class PaymentsController < ApplicationController
      skip_before_action :verify_authenticity_token
      require 'net/http'

      def index
        authorize Payment
        if params[:fetch_data] == "true"
          fetch_payment_data
          return
        end

        # Pagination parameters
        page = params[:page]&.to_i || 1
        per_page = params[:per_page]&.to_i || 20
        per_page = [per_page, 100].min

        start_date = params[:start_date]&.to_date || 1.month.ago.beginning_of_month
        end_date = params[:end_date]&.to_date || Time.current.to_date

        payments = Payment.where(
          created_at_api: start_date.beginning_of_day..end_date.end_of_day,
          status: 'Settled',
          payment_type: ['Sale', 'Return']
        )

        # Apply payment type filter if specified
        if params[:payment_type].present? && params[:payment_type] != 'all'
          case params[:payment_type]
          when 'recurring'
            payments = payments.where(recurring: true)
          when 'single'
            payments = payments.where(recurring: false)
          end
        end

        # Sorting
        sort_column = params[:sort_by] || 'created_at_api'
        sort_direction = params[:sort_direction] || 'desc'
        
        # Validate sort column for security
        allowed_sort_columns = ['created_at_api', 'amount', 'tender_type', 'payment_type', 'source']
        sort_column = 'created_at_api' unless allowed_sort_columns.include?(sort_column)
        
        payments = payments.order("#{sort_column} #{sort_direction}")

        # Pagination
        total_count = payments.count
        total_pages = (total_count.to_f / per_page).ceil
        payments = payments.limit(per_page).offset((page - 1) * per_page)

        render json: {
          data: payments,
          pagination: {
            current_page: page,
            per_page: per_page,
            total_pages: total_pages,
            total_count: total_count
          }
        }, status: :ok
      end

      def sync
        authorize Payment
        result = ExternalPaymentSyncService.sync

        if result[:status] == "success"
          render json: {message: "Payments synced successfully"}, status: :ok
        else
          render json: {message: "Failed to sync payments"}, status: :unprocessable_entity
        end
      end

      def report
        authorize Payment
        start_date = params[:start_date] || 1.month.ago.beginning_of_month
        end_date = params[:end_date] || Time.current
        payment_type = params[:payment_type] || 'all'

        report = RevenueReport.new(start_date, end_date, payment_type)
        render json: report.generate_report
      end
    end
  end
end
