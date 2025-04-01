module MetricsUtil
  def self.percent_change(current, previous)
    return nil if previous.zero?
    (((current - previous) / previous.to_f) * 100).round(2)
  end
end