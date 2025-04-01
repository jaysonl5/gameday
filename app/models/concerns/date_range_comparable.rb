module DateRangeComparable
  extend ActiveSupport::Concern

  def previous_range(start_date, end_date)
    delta = end_date - start_date
    [start_date - delta, end_date - delta]
  end
end
