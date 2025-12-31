class AddPatientIdToPatientCensusEntries < ActiveRecord::Migration[7.0]
  def change
    add_reference :patient_census_entries, :patient, null: false, foreign_key: true
  end
end
