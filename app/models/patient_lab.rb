class PatientLab < ApplicationRecord
  # Soft deletes
  acts_as_paranoid

  # Audit trail
  has_paper_trail

  # Encryption
  attr_encrypted :notes, key: ENV['ENCRYPTION_KEY']

  # Associations
  belongs_to :patient
  belongs_to :patient_medication, optional: true

  # Polymorphic association for lab order calls
  has_many :patient_calls, as: :callable, dependent: :destroy

  # Validations
  validates :patient, presence: true
  validates :lab_type, presence: true
  validates :frequency_value, presence: true, numericality: {
    greater_than: 0,
    only_integer: true
  }
  validates :frequency_unit, presence: true, inclusion: {
    in: %w[weeks months]
  }
  validates :status, inclusion: {
    in: %w[OK DUE_SOON OVERDUE],
    allow_nil: true
  }

  # Callbacks
  before_save :calculate_next_lab_due
  before_save :calculate_status
  after_save :schedule_lab_order_call, if: :due_soon?

  # Scopes
  scope :overdue, -> { where(status: 'OVERDUE') }
  scope :due_soon, -> { where(status: 'DUE_SOON') }
  scope :ok, -> { where(status: 'OK') }
  scope :by_next_lab_due, -> { order(next_lab_due: :asc) }
  scope :by_lab_type, ->(type) { where(lab_type: type) }
  scope :needs_attention, -> { where(status: %w[OVERDUE DUE_SOON]) }
  scope :weekly, -> { where(frequency_unit: 'weeks') }
  scope :monthly, -> { where(frequency_unit: 'months') }

  # Instance methods
  def overdue?
    status == 'OVERDUE'
  end

  def due_soon?
    status == 'DUE_SOON'
  end

  def frequency_description
    "Every #{frequency_value} #{frequency_unit}"
  end

  def days_until_due
    return nil if next_lab_due.blank?
    (next_lab_due - Date.current).to_i
  end

  private

  def calculate_next_lab_due
    return if last_lab_date.blank? || frequency_value.blank? || frequency_unit.blank?

    case frequency_unit
    when 'weeks'
      self.next_lab_due = last_lab_date + (frequency_value * 7).days
    when 'months'
      self.next_lab_due = last_lab_date + frequency_value.months
    end
  end

  def calculate_status
    return if next_lab_due.blank?

    today = Date.current
    one_week_before = next_lab_due - 1.week

    self.status = if today >= next_lab_due
      'OVERDUE'
    elsif today >= one_week_before
      'DUE_SOON'
    else
      'OK'
    end
  end

  def schedule_lab_order_call
    return if next_lab_due.blank?

    scheduled_date = next_lab_due - 1.week
    return if scheduled_date < Date.current

    # Only create if one doesn't already exist
    return if patient.patient_calls.exists?(
      callable: self,
      call_type: 'lab_order',
      completed_at: nil
    )

    patient.patient_calls.create!(
      callable: self,
      call_type: 'lab_order',
      scheduled_date: scheduled_date
    )
  end
end
