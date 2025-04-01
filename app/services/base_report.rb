class BaseReport
  include DateRangeComparable

  attr_reader :start_date, :end_date

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def period_length
    end_date - start_date
  end

  def previous_range
    super(start_date, end_date)
  end
end