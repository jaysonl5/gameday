class CreateGhlAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :ghl_appointments do |t|
      t.references :patient, foreign_key: true # May be null if patient not yet created

      # GHL data
      t.string :ghl_appointment_id, null: false # External ID from GoHighLevel
      t.string :ghl_calendar_id
      t.string :appointment_status # confirmed, cancelled, no_show, etc.
      t.datetime :scheduled_at
      t.datetime :end_time
      t.string :appointment_type # consult, follow_up, etc.
      t.text :notes

      # Tracking
      t.boolean :patient_created, default: false # Did we auto-create patient from this?
      t.datetime :synced_at # Last time we synced from GHL

      t.timestamps
    end

    add_index :ghl_appointments, :ghl_appointment_id, unique: true
    add_index :ghl_appointments, :appointment_status
    add_index :ghl_appointments, :scheduled_at
    add_index :ghl_appointments, :patient_created
  end
end
