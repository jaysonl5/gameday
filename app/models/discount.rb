class Discount < ApplicationRecord
  # Audit trail
  has_paper_trail

  # Associations
  has_many :patient_profiles, dependent: :restrict_with_error
  has_many :patient_medications, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true
  validates :percentage, numericality: {
    greater_than: 0,
    less_than_or_equal_to: 100
  }, if: :percentage?
  validates :fixed_amount, numericality: {
    greater_than: 0
  }, if: :fixed_amount?
  validate :has_either_percentage_or_fixed_amount

  # Scopes
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :percentage_based, -> { where.not(percentage: nil) }
  scope :fixed_amount_based, -> { where.not(fixed_amount: nil) }
  scope :alphabetical, -> { order(name: :asc) }

  # Instance methods
  def display_name
    name
  end

  def apply_to_amount(amount_cents)
    return amount_cents unless active?

    if percentage.present?
      discount_amount = (amount_cents * percentage / 100.0).round
      amount_cents - discount_amount
    elsif fixed_amount.present?
      [amount_cents - fixed_amount, 0].max # Don't go below 0
    else
      amount_cents
    end
  end

  def deactivate!
    update!(active: false)
  end

  def activate!
    update!(active: true)
  end

  private

  def has_either_percentage_or_fixed_amount
    if percentage.blank? && fixed_amount.blank?
      errors.add(:base, 'Must have either percentage or fixed amount')
    elsif percentage.present? && fixed_amount.present?
      errors.add(:base, 'Cannot have both percentage and fixed amount')
    end
  end
end
