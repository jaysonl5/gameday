class PatientCensusEntry < ApplicationRecord
  validates :date, presence: true
  validates :patient_name, presence: true
  validates :patient_result, presence: true, inclusion: { in: %w[Win Thinker Loss] }

  validates :phone_number, presence: true, if: :thinker?
  validates :p_or_other, presence: true, if: -> { thinker? || loss? }
  validates :why_a_loss, presence: true, if: :loss?

  validates :mail_out_in_clinic, presence: true, if: :win?
  validates :lead_source, presence: true, if: :win?

  scope :wins, -> { where(patient_result: 'Win') }
  scope :thinkers, -> { where(patient_result: 'Thinker') }
  scope :losses, -> { where(patient_result: 'Loss') }

  def win?
    patient_result == 'Win'
  end

  def thinker?
    patient_result == 'Thinker'
  end

  def loss?
    patient_result == 'Loss'
  end

  def plan_list
    return [] if plan.blank?
    JSON.parse(plan) rescue []
  end

  def plan_list=(value)
    self.plan = value.is_a?(Array) ? value.to_json : value
  end
end