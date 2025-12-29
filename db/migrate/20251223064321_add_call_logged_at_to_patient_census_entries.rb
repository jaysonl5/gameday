class AddCallLoggedAtToPatientCensusEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :patient_census_entries, :call_logged_at, :datetime
  end
end
