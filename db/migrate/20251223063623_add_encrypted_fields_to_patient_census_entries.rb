class AddEncryptedFieldsToPatientCensusEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :patient_census_entries, :encrypted_patient_name, :string
    add_column :patient_census_entries, :encrypted_patient_name_iv, :string
    add_column :patient_census_entries, :encrypted_phone_number, :string
    add_column :patient_census_entries, :encrypted_phone_number_iv, :string
    add_column :patient_census_entries, :encrypted_notes, :text
    add_column :patient_census_entries, :encrypted_notes_iv, :string
    add_column :patient_census_entries, :encrypted_plan_notes, :text
    add_column :patient_census_entries, :encrypted_plan_notes_iv, :string
    add_column :patient_census_entries, :encrypted_extra_info, :text
    add_column :patient_census_entries, :encrypted_extra_info_iv, :string
    add_column :patient_census_entries, :encrypted_why_a_loss, :text
    add_column :patient_census_entries, :encrypted_why_a_loss_iv, :string
  end
end
