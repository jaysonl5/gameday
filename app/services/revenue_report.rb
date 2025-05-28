# frozen_string_literal: true

class RevenueReport < BaseReport
  VALID_PAYMENT_TYPES = %w[all recurring single].freeze
  REVENUE_AFFECTING_TYPES = %w[Sale Return].freeze
  SETTLED_STATUS = 'Settled'

  def initialize(start_date, end_date, payment_type = 'all')
    @start_date = start_date
    @end_date = end_date
    @payment_type = validate_payment_type(payment_type)
  end

  def generate_report
    {
      total_revenue: calculate_total_revenue,
      payment_breakdown: generate_payment_breakdown,
      date_range: date_range_summary,
      filters_applied: filters_summary
    }
  end

  private

  def base_payments
    @base_payments ||= Payment.where(
      created_at_api: date_range,
      status: SETTLED_STATUS,
      payment_type: REVENUE_AFFECTING_TYPES
    ).then { |scope| apply_payment_type_filter(scope) }
  end

  def date_range
    @date_range ||= @start_date.to_time.beginning_of_day..@end_date.to_time.end_of_day
  end

  def apply_payment_type_filter(scope)
    case @payment_type
    when 'recurring'
      scope.where(recurring: true)
    when 'single'
      scope.where(recurring: false)
    else
      scope
    end
  end

  def calculate_total_revenue
    sales_total = base_payments.where(payment_type: 'Sale').sum(:amount)
    returns_total = base_payments.where(payment_type: 'Return').sum(:amount)
    
    sales_total - returns_total
  end

  def generate_payment_breakdown
    {
      by_day: breakdown_by_day,
      by_source: breakdown_by_source,
      by_type: breakdown_by_type,
      by_month: breakdown_by_month,
      total_count: base_payments.count
    }
  end

  def breakdown_by_day
    grouped_data = calculate_net_amounts_grouped_by(["DATE(created_at_api)", :source])
    
    grouped_data.map { |(date, source), amount|
      { date: date.to_s, source: source, amount: amount.to_f }
    }
  end

  def breakdown_by_source
    calculate_net_amounts_grouped_by(:source)
  end

  def breakdown_by_type
    calculate_net_amounts_grouped_by(:payment_type)
  end

  def breakdown_by_month
    calculate_net_amounts_grouped_by("DATE_TRUNC('month', created_at_api)")
  end

  def calculate_net_amounts_grouped_by(group_by)
    net_amounts = {}
    
    # Add sales amounts
    base_payments.where(payment_type: 'Sale')
                 .group(group_by)
                 .sum(:amount)
                 .each { |key, amount| net_amounts[key] = (net_amounts[key] || 0) + amount }
    
    # Subtract return amounts
    base_payments.where(payment_type: 'Return')
                 .group(group_by)
                 .sum(:amount)
                 .each { |key, amount| net_amounts[key] = (net_amounts[key] || 0) - amount }
    
    net_amounts
  end

  def date_range_summary
    {
      start_date: @start_date,
      end_date: @end_date
    }
  end

  def filters_summary
    {
      payment_type: @payment_type,
      status_filter: SETTLED_STATUS,
      included_types: REVENUE_AFFECTING_TYPES
    }
  end

  def validate_payment_type(payment_type)
    return payment_type if VALID_PAYMENT_TYPES.include?(payment_type)
    
    raise ArgumentError, "Invalid payment_type: #{payment_type}. Valid options: #{VALID_PAYMENT_TYPES.join(', ')}"
  end
end