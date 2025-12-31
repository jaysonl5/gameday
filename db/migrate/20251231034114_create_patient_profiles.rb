class CreatePatientProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :patient_profiles do |t|
      t.references :patient, null: false, foreign_key: true
      t.references :discount, foreign_key: true

      # Contract/business fields
      t.string :lead_source
      t.integer :rate # Base rate for patient (cents - best practice for currency)
      t.boolean :monthly_contract_made, default: false
      t.boolean :annual_contract_made, default: false

      # Census tracking (kept for historical data)
      t.string :patient_result # Win, Thinker, Loss (from original census)
      t.date :consult_date
      t.text :encrypted_extra_info
      t.string :encrypted_extra_info_iv

      t.datetime :deleted_at
      t.timestamps
    end

    add_index :patient_profiles, :patient_result
    add_index :patient_profiles, :consult_date
    add_index :patient_profiles, :deleted_at
  end
end
