class PatientMedication < ApplicationRecord
  # Soft deletes
  acts_as_paranoid

  # Audit trail
  has_paper_trail

  # Encryption
  attr_encrypted :notes, key: ENV['ENCRYPTION_KEY']

  # Associations
  belongs_to :patient
  belongs_to :medication
  belongs_to :discount, optional: true

  # Polymorphic association for medication refill calls (future)
  has_many :patient_calls, as: :callable, dependent: :destroy
  has_many :patient_labs, dependent: :nullify

  # Validations
  validates :patient, presence: true
  validates :medication, presence: true
  validates :dose_per_week, presence: true, numericality: { greater_than: 0 }
  validates :vial_size, presence: true, numericality: { greater_than: 0 }
  validates :order_buffer_days, numericality: { greater_than_or_equal_to: 0 }
  validates :rate, numericality: { greater_than: 0 }, allow_nil: true
  validates :dispensing_method, inclusion: {
    in: %w[mail_out in_clinic],
    allow_nil: true
  }
  validates :in_clinic_dose, numericality: { greater_than: 0 }, if: :in_clinic?
  validates :status, inclusion: {
    in: %w[OK DUE_SOON OVERDUE],
    allow_nil: true
  }

  # Callbacks
  before_save :calculate_days_supply
  before_save :calculate_next_order_due
  before_save :calculate_order_by_date
  before_save :calculate_status
  after_save :schedule_lab_order_call, if: :should_schedule_lab_call?

  # Scopes
  scope :active, -> { where(declined: false) }
  scope :declined, -> { where(declined: true) }
  scope :prepped, -> { where(prepped: true) }
  scope :not_prepped, -> { where(prepped: false) }
  scope :mail_out, -> { where(dispensing_method: 'mail_out') }
  scope :in_clinic, -> { where(dispensing_method: 'in_clinic') }
  scope :overdue, -> { where(status: 'OVERDUE') }
  scope :due_soon, -> { where(status: 'DUE_SOON') }
  scope :ok, -> { where(status: 'OK') }
  scope :by_next_order_due, -> { order(next_order_due: :asc) }
  scope :needs_attention, -> { where(status: %w[OVERDUE DUE_SOON]) }

  # Instance methods
  def in_clinic?
    dispensing_method == 'in_clinic'
  end

  def mail_out?
    dispensing_method == 'mail_out'
  end

  def overdue?
    status == 'OVERDUE'
  end

  def due_soon?
    status == 'DUE_SOON'
  end

  def effective_rate_cents
    rate || patient.patient_profile&.rate || 0
  end

  def apply_discount(amount_cents)
    return amount_cents unless discount&.active?
    discount.apply_to_amount(amount_cents)
  end

  def final_rate_cents
    apply_discount(effective_rate_cents)
  end

  private

  def calculate_days_supply
    return if dose_per_week.blank? || vial_size.blank?

    # days_supply = (vial_size / dose_per_week) * 7
    self.days_supply = ((vial_size / dose_per_week) * 7).to_i
  end

  def calculate_next_order_due
    return if last_order_date.blank? || days_supply.blank?

    self.next_order_due = last_order_date + days_supply.days
  end

  def calculate_order_by_date
    return if next_order_due.blank?

    buffer = order_buffer_days || 7
    self.order_by_date = next_order_due - buffer.days
  end

  def calculate_status
    return if order_by_date.blank?

    today = Date.current
    self.status = if today >= next_order_due
      'OVERDUE'
    elsif today >= order_by_date
      'DUE_SOON'
    else
      'OK'
    end
  end

  def should_schedule_lab_call?
    # Only schedule if we have associated labs and they're due soon
    patient_labs.any? && status == 'DUE_SOON'
  end

  def schedule_lab_order_call
    patient_labs.each do |lab|
      next if lab.next_lab_due.blank?

      scheduled_date = lab.next_lab_due - 1.week
      next if scheduled_date < Date.current

      # Only create if one doesn't already exist
      next if patient.patient_calls.exists?(
        callable: lab,
        call_type: 'lab_order',
        completed_at: nil
      )

      patient.patient_calls.create!(
        callable: lab,
        call_type: 'lab_order',
        scheduled_date: scheduled_date
      )
    end
  end
end
