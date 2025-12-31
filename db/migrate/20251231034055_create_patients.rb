class CreatePatients < ActiveRecord::Migration[7.0]
  def change
    create_table :patients do |t|
      # Encrypted PHI with blind indexes for search
      t.string :encrypted_name
      t.string :encrypted_name_iv
      t.string :encrypted_name_bidx # Blind index for searching by name

      t.string :encrypted_email
      t.string :encrypted_email_iv
      t.string :encrypted_email_bidx # Blind index for searching by email

      t.string :encrypted_phone
      t.string :encrypted_phone_iv

      t.text :encrypted_notes
      t.string :encrypted_notes_iv

      # Status tracking (replaces patient_stage - combined into one field)
      # Values: new_lead, thinker, active, paused, cancelled, no_show, do_not_service
      t.string :status, null: false, default: 'new_lead'
      t.datetime :status_changed_at # Track when status updates

      # GHL integration
      t.string :ghl_contact_id

      # Soft deletes
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :patients, :status
    add_index :patients, :encrypted_name_bidx
    add_index :patients, :encrypted_email_bidx
    add_index :patients, :deleted_at
    add_index :patients, :status_changed_at
    add_index :patients, :ghl_contact_id, unique: true
  end
end
