class Payment < ApplicationRecord
  has_paper_trail

  validates :api_id, presence: true, uniqueness: true

  scope :recurring, -> { where(recurring: true) }
  scope :returned, -> { where(payment_type: 'Return')}
  #statuses
  scope :approved, -> { where(status: 'Settled') }
  scope :declined, -> { where(status: 'Declined') }
  scope :voided, -> { where(status: 'Voided') }

end
