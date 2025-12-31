class GhlSyncLog < ApplicationRecord
  # Validations
  validates :sync_type, presence: true
  validates :status, presence: true, inclusion: {
    in: %w[success partial failed]
  }

  # Scopes
  scope :successful, -> { where(status: 'success') }
  scope :partial, -> { where(status: 'partial') }
  scope :failed, -> { where(status: 'failed') }
  scope :by_type, ->(type) { where(sync_type: type) }
  scope :recent, -> { order(started_at: :desc) }
  scope :appointments, -> { where(sync_type: 'appointments') }
  scope :contacts, -> { where(sync_type: 'contacts') }

  # Class methods
  def self.start_sync(sync_type)
    create!(
      sync_type: sync_type,
      status: 'failed', # Default to failed, update on success
      started_at: Time.current,
      records_processed: 0,
      records_created: 0,
      records_updated: 0,
      records_failed: 0
    )
  end

  # Instance methods
  def mark_success!
    update!(
      status: 'success',
      completed_at: Time.current
    )
  end

  def mark_partial!
    update!(
      status: 'partial',
      completed_at: Time.current
    )
  end

  def mark_failed!(error)
    update!(
      status: 'failed',
      error_message: error.to_s,
      completed_at: Time.current
    )
  end

  def increment_processed!
    increment!(:records_processed)
  end

  def increment_created!
    increment!(:records_created)
  end

  def increment_updated!
    increment!(:records_updated)
  end

  def increment_failed!
    increment!(:records_failed)
  end

  def duration_seconds
    return nil unless started_at.present?
    end_time = completed_at || Time.current
    (end_time - started_at).to_i
  end

  def success?
    status == 'success'
  end

  def partial?
    status == 'partial'
  end

  def failed?
    status == 'failed'
  end
end
