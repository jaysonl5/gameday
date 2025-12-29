# frozen_string_literal: true

class PatientCensusStatsService
  def initialize(filter: :this_week)
    @filter = filter
  end

  def win_rate_day
    calculate_win_rate(1.day.ago..Time.current)
  end

  def win_rate_week
    calculate_win_rate(7.days.ago..Time.current)
  end

  def win_rate_month
    calculate_win_rate(30.days.ago..Time.current)
  end

  def thinkers_to_call
    thinkers = PatientCensusEntry.thinkers
      .where('created_at >= ?', filter_start_date)
      .where(call_logged_at: nil)
      .order(created_at: :desc)

    thinkers.map do |thinker|
      {
        id: thinker.id,
        name: thinker.patient_name,
        phone: thinker.phone_number,
        date: thinker.date,
        notes: thinker.notes || thinker.extra_info
      }
    end
  end

  def stats
    {
      win_rate_day: win_rate_day,
      win_rate_week: win_rate_week,
      win_rate_month: win_rate_month,
      thinkers: thinkers_to_call
    }
  end

  private

  def calculate_win_rate(date_range)
    entries = PatientCensusEntry.where(date: date_range)
    total = entries.count
    return { percentage: 0, wins: 0, total: 0 } if total.zero?

    wins = entries.wins.count
    percentage = ((wins.to_f / total) * 100).round(2)

    {
      percentage: percentage,
      wins: wins,
      total: total
    }
  end

  def filter_start_date
    case @filter
    when :this_week
      7.days.ago
    when :this_month
      30.days.ago
    else # :all_time
      100.years.ago
    end
  end
end
