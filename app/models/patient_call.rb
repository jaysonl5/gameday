class PatientCall < ApplicationRecord
  # Soft deletes
  acts_as_paranoid

  # Audit trail
  has_paper_trail

  # Encryption
  attr_encrypted :notes, key: ENV['ENCRYPTION_KEY']

  # Associations
  belongs_to :patient
  belongs_to :callable, polymorphic: true

  # Validations
  validates :patient, presence: true
  validates :callable, presence: true
  validates :call_type, presence: true, inclusion: {
    in: %w[thinker_followup lab_order medication_refill]
  }
  validates :scheduled_date, presence: true
  validates :outcome, inclusion: {
    in: %w[answered no_answer voicemail rescheduled cancelled],
    allow_nil: true
  }

  # Scopes
  scope :pending, -> { where(completed_at: nil) }
  scope :completed, -> { where.not(completed_at: nil) }
  scope :thinker_followups, -> { where(call_type: 'thinker_followup') }
  scope :lab_orders, -> { where(call_type: 'lab_order') }
  scope :medication_refills, -> { where(call_type: 'medication_refill') }
  scope :due_today, -> { where(scheduled_date: Date.current, completed_at: nil) }
  scope :overdue, -> { where('scheduled_date < ? AND completed_at IS NULL', Date.current) }
  scope :upcoming, -> { where('scheduled_date > ?', Date.current) }
  scope :by_scheduled_date, -> { order(scheduled_date: :asc) }
  scope :recent, -> { order(scheduled_date: :desc) }
  scope :answered, -> { where(outcome: 'answered') }
  scope :no_answer, -> { where(outcome: 'no_answer') }

  # Instance methods
  def pending?
    completed_at.nil?
  end

  def completed?
    completed_at.present?
  end

  def overdue?
    pending? && scheduled_date < Date.current
  end

  def due_today?
    pending? && scheduled_date == Date.current
  end

  def upcoming?
    pending? && scheduled_date > Date.current
  end

  def mark_completed!(outcome_value, notes_text = nil)
    update!(
      completed_at: Time.current,
      outcome: outcome_value,
      notes: notes_text
    )
  end

  def thinker_followup?
    call_type == 'thinker_followup'
  end

  def lab_order?
    call_type == 'lab_order'
  end

  def medication_refill?
    call_type == 'medication_refill'
  end

  def call_type_display
    call_type.humanize
  end

  def days_until_scheduled
    return nil if scheduled_date.blank?
    (scheduled_date - Date.current).to_i
  end
end
