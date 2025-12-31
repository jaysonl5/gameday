class PatientProfile < ApplicationRecord
  # Soft deletes
  acts_as_paranoid

  # Audit trail
  has_paper_trail

  # Encryption
  attr_encrypted :extra_info, key: ENV['ENCRYPTION_KEY']

  # Associations
  belongs_to :patient
  belongs_to :discount, optional: true

  # Polymorphic association for thinker follow-up calls
  has_many :patient_calls, as: :callable, dependent: :destroy

  # Validations
  validates :patient, presence: true
  validates :patient_result, inclusion: {
    in: %w[Win Thinker Loss],
    allow_nil: true
  }
  validates :rate, numericality: { greater_than: 0 }, allow_nil: true

  # Scopes
  scope :wins, -> { where(patient_result: 'Win') }
  scope :thinkers, -> { where(patient_result: 'Thinker') }
  scope :losses, -> { where(patient_result: 'Loss') }
  scope :with_monthly_contract, -> { where(monthly_contract_made: true) }
  scope :with_annual_contract, -> { where(annual_contract_made: true) }
  scope :by_lead_source, ->(source) { where(lead_source: source) }
  scope :recent_consults, -> { where('consult_date >= ?', 30.days.ago) }
  scope :by_consult_date, -> { order(consult_date: :desc) }

  # Callbacks
  after_create :schedule_thinker_followup_call, if: :thinker?

  # Instance methods
  def thinker?
    patient_result == 'Thinker'
  end

  def win?
    patient_result == 'Win'
  end

  def loss?
    patient_result == 'Loss'
  end

  def has_contract?
    monthly_contract_made? || annual_contract_made?
  end

  def effective_rate_cents
    rate || patient.patient_profile&.rate || 0
  end

  def apply_discount(amount_cents)
    return amount_cents unless discount&.active?
    discount.apply_to_amount(amount_cents)
  end

  private

  def schedule_thinker_followup_call
    return unless consult_date.present?

    scheduled_date = consult_date + 1.week
    patient.patient_calls.create!(
      callable: self,
      call_type: 'thinker_followup',
      scheduled_date: scheduled_date
    )
  end
end
