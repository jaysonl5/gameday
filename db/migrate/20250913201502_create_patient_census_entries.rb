class CreatePatientCensusEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :patient_census_entries do |t|
      t.date :date, null: false
      t.string :patient_name, null: false
      t.string :patient_result, null: false
      
      # WIN fields
      t.string :mail_out_in_clinic
      t.decimal :in_clinic_dose_ml, precision: 5, scale: 2
      t.string :med_order_made
      t.string :lab_call_scheduled
      t.string :monthly_contract_made
      t.string :annual_lab_contract
      t.string :consents_signed
      t.string :in_clinic_appt_made
      t.string :mail_out_appt_made
      t.text :notes
      t.string :lead_source
      t.text :plan_notes
      t.integer :rate
      t.text :extra_info
      
      # THINKER fields
      t.string :p_or_other
      t.string :phone_number
      
      # LOSS fields
      t.text :why_a_loss
      
      # Shared fields
      t.json :plan

      t.timestamps
    end

    add_index :patient_census_entries, :patient_result
    add_index :patient_census_entries, :date
  end
end
