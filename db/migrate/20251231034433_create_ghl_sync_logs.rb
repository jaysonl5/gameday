class CreateGhlSyncLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :ghl_sync_logs do |t|
      t.string :sync_type, null: false # appointments, contacts, etc.
      t.string :status, null: false # success, partial, failed
      t.integer :records_processed, default: 0
      t.integer :records_created, default: 0
      t.integer :records_updated, default: 0
      t.integer :records_failed, default: 0
      t.text :error_message
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end

    add_index :ghl_sync_logs, :sync_type
    add_index :ghl_sync_logs, :status
    add_index :ghl_sync_logs, :started_at
  end
end
