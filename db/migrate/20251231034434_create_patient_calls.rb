class CreatePatientCalls < ActiveRecord::Migration[7.0]
  def change
    create_table :patient_calls do |t|
      t.references :patient, null: false, foreign_key: true

      # Polymorphic association - what triggered this call?
      # callable_type: ThinkerFollowup, LabOrder, MedicationRefill (future)
      # callable_id: ID of the PatientProfile, PatientLab, or PatientMedication
      t.references :callable, polymorphic: true, null: false

      # Call details
      t.string :call_type, null: false # thinker_followup, lab_order, medication_refill
      t.date :scheduled_date, null: false
      t.datetime :completed_at
      t.string :outcome # answered, no_answer, voicemail, rescheduled, cancelled
      t.text :encrypted_notes
      t.string :encrypted_notes_iv

      t.datetime :deleted_at
      t.timestamps
    end

    add_index :patient_calls, [:callable_type, :callable_id]
    add_index :patient_calls, :call_type
    add_index :patient_calls, :scheduled_date
    add_index :patient_calls, :completed_at
    add_index :patient_calls, :deleted_at
  end
end
