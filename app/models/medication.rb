class Medication < ApplicationRecord
  # Audit trail
  has_paper_trail

  # Associations
  has_many :patient_medications, dependent: :restrict_with_error
  has_many :patients, through: :patient_medications

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :default_dose, numericality: { greater_than: 0 }, allow_nil: true

  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :alphabetical, -> { order(name: :asc) }

  # Instance methods
  def display_name
    name
  end

  def deactivate!
    update!(active: false)
  end

  def activate!
    update!(active: true)
  end
end
