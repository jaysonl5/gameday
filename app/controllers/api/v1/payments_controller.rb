module Api
  module V1
    class PaymentsController < ApplicationController
      require 'net/http'

      def index
        if params[:fetch_data] == "true"
          fetch_payment_data
          return
        end
          payments = Payment.all
          render json: payments, status: :ok
      end

      def sync 
        result = ExternalPaymentSyncService.sync

        if result[:status] == "success"
          render json: {message: "Payments synced successfully"}, status: :ok
        else
          render json: {message: "Failed to sync payments"}, status: :unprocessable_entity
        end
      end
    

      def report
        start_date = params[:start_date] || 1.month.ago.beginning_of_month
        end_date = params[:end_date] || Time.current
        payment_type = params[:payment_type] || 'all'

        report = RevenueReport.new(start_date, end_date, payment_type)
        render json: report.generate_report
      end
    end
  end
end
