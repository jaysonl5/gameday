class CreatePatientMedications < ActiveRecord::Migration[7.0]
  def change
    create_table :patient_medications do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :medication, null: false, foreign_key: true
      t.references :discount, foreign_key: true

      # Medication details
      t.boolean :prepped, default: false
      t.decimal :dose_per_week, precision: 5, scale: 2, null: false
      t.decimal :vial_size, precision: 5, scale: 2, null: false
      t.integer :rate # Per-medication rate override (cents)

      # Dispensing method (per-medication, not per-patient)
      t.string :dispensing_method # mail_out, in_clinic
      t.decimal :in_clinic_dose, precision: 5, scale: 2 # For in-clinic medications

      # Order tracking
      t.date :last_order_date
      t.integer :order_buffer_days, default: 7
      t.boolean :declined, default: false

      # Calculated/denormalized fields (updated via callbacks)
      t.integer :days_supply
      t.date :next_order_due
      t.date :order_by_date
      t.string :status # OK, DUE_SOON, OVERDUE

      # PHI
      t.text :encrypted_notes
      t.string :encrypted_notes_iv

      t.datetime :deleted_at
      t.timestamps
    end

    add_index :patient_medications, [:patient_id, :medication_id]
    add_index :patient_medications, :status
    add_index :patient_medications, :next_order_due
    add_index :patient_medications, :order_by_date
    add_index :patient_medications, :dispensing_method
    add_index :patient_medications, :deleted_at
  end
end
