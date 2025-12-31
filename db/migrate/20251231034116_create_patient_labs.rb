class CreatePatientLabs < ActiveRecord::Migration[7.0]
  def change
    create_table :patient_labs do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :patient_medication, foreign_key: true # Optional - which medication requires this lab

      # Lab details
      t.string :lab_type, null: false # e.g., "Testosterone", "CBC", "CMP"
      t.date :last_lab_date
      t.integer :frequency_value, null: false # e.g., 3 for "every 3 months"
      t.string :frequency_unit, null: false # weeks, months

      # Calculated/denormalized fields (updated via callbacks)
      t.date :next_lab_due
      t.string :status # OK, DUE_SOON, OVERDUE

      # PHI
      t.text :encrypted_notes
      t.string :encrypted_notes_iv

      t.datetime :deleted_at
      t.timestamps
    end

    add_index :patient_labs, :next_lab_due
    add_index :patient_labs, :status
    add_index :patient_labs, :deleted_at
  end
end
