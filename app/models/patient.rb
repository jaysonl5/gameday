class Patient < ApplicationRecord
  # Soft deletes
  acts_as_paranoid

  # Audit trail
  has_paper_trail

  # Encryption
  attr_encrypted :name, key: ENV['ENCRYPTION_KEY']
  attr_encrypted :email, key: ENV['ENCRYPTION_KEY']
  attr_encrypted :phone, key: ENV['ENCRYPTION_KEY']
  attr_encrypted :notes, key: ENV['ENCRYPTION_KEY']

  # Blind indexes for searchable encryption
  blind_index :name, key: ENV['BLIND_INDEX_KEY']
  blind_index :email, key: ENV['BLIND_INDEX_KEY']

  # Associations
  has_one :patient_profile, dependent: :destroy
  has_many :patient_medications, dependent: :destroy
  has_many :medications, through: :patient_medications
  has_many :patient_labs, dependent: :destroy
  has_many :patient_calls, dependent: :destroy
  has_many :ghl_appointments, dependent: :nullify
  has_many :patient_census_entries, dependent: :nullify

  # Validations
  validates :status, presence: true, inclusion: {
    in: %w[new_lead thinker active paused cancelled no_show do_not_service]
  }

  # Callbacks
  before_update :track_status_change, if: :status_changed?

  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :thinkers, -> { where(status: 'thinker') }
  scope :new_leads, -> { where(status: 'new_lead') }
  scope :paused, -> { where(status: 'paused') }
  scope :cancelled, -> { where(status: 'cancelled') }
  scope :by_status, ->(status) { where(status: status) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_ghl_id, ->(ghl_id) { where(ghl_contact_id: ghl_id) }

  # Instance methods
  def display_name
    name || "Patient ##{id}"
  end

  def active?
    status == 'active'
  end

  def thinker?
    status == 'thinker'
  end

  def overdue_medications
    patient_medications.where(status: 'OVERDUE')
  end

  def due_soon_medications
    patient_medications.where(status: 'DUE_SOON')
  end

  def overdue_labs
    patient_labs.where(status: 'OVERDUE')
  end

  def due_soon_labs
    patient_labs.where(status: 'DUE_SOON')
  end

  def pending_calls
    patient_calls.where(completed_at: nil).order(scheduled_date: :asc)
  end

  private

  def track_status_change
    self.status_changed_at = Time.current
  end
end
