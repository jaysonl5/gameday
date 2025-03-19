# frozen_string_literal: true

class RevenueReport
  def initialize(start_date, end_date, payment_type = 'all')
    @start_date = start_date
    @end_date = end_date
    @payment_type = payment_type
  end

  def generate_report
    payments = fetch_payments
    {
      total_revenue: calculate_total_revenue(payments),
      payment_breakdown: generate_payment_breakdown(payments),
      date_range: {
        start_date: @start_date,
        end_date: @end_date
      }
    }
  end

  private

  def fetch_payments
    scope = Payment.where(created_at: @start_date..@end_date)
    
    case @payment_type
    when 'recurring'
      scope.where(recurring: true)
    when 'single'
      scope.where(recurring: false)
    else
      scope
    end
  end

  def calculate_total_revenue(payments)
    payments.sum(:amount)
  end

  def generate_payment_breakdown(payments)
    {
      by_type: payments.group(:payment_type).sum(:amount),
      by_month: payments.group("DATE_TRUNC('month', created_at)").sum(:amount),
      total_count: payments.count
    }
  end
end

