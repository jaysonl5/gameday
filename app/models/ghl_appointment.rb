class GhlAppointment < ApplicationRecord
  # Audit trail
  has_paper_trail

  # Associations
  belongs_to :patient, optional: true

  # Validations
  validates :ghl_appointment_id, presence: true, uniqueness: true
  validates :appointment_status, inclusion: {
    in: %w[confirmed cancelled no_show completed rescheduled],
    allow_nil: true
  }

  # Scopes
  scope :confirmed, -> { where(appointment_status: 'confirmed') }
  scope :cancelled, -> { where(appointment_status: 'cancelled') }
  scope :no_show, -> { where(appointment_status: 'no_show') }
  scope :completed, -> { where(appointment_status: 'completed') }
  scope :without_patient, -> { where(patient_id: nil) }
  scope :with_patient, -> { where.not(patient_id: nil) }
  scope :patient_created, -> { where(patient_created: true) }
  scope :upcoming, -> { where('scheduled_at >= ?', Time.current).order(scheduled_at: :asc) }
  scope :past, -> { where('scheduled_at < ?', Time.current).order(scheduled_at: :desc) }
  scope :recent, -> { order(scheduled_at: :desc) }
  scope :consults, -> { where(appointment_type: 'consult') }

  # Instance methods
  def confirmed?
    appointment_status == 'confirmed'
  end

  def cancelled?
    appointment_status == 'cancelled'
  end

  def no_show?
    appointment_status == 'no_show'
  end

  def completed?
    appointment_status == 'completed'
  end

  def upcoming?
    scheduled_at.present? && scheduled_at >= Time.current
  end

  def needs_patient_creation?
    patient_id.nil? && confirmed? && appointment_type == 'consult'
  end

  def mark_synced!
    update!(synced_at: Time.current)
  end
end
