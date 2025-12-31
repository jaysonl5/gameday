class DashboardStatsService
  def initialize(patient_id: nil)
    @patient_id = patient_id
  end

  # Get comprehensive dashboard stats
  def stats
    if @patient_id
      patient_stats
    else
      global_stats
    end
  end

  # Global dashboard stats (all patients)
  def global_stats
    {
      patients: patient_counts,
      medications: medication_stats,
      labs: lab_stats,
      calls: call_stats,
      appointments: appointment_stats,
      alerts: alert_counts
    }
  end

  # Individual patient dashboard stats
  def patient_stats
    patient = Patient.find(@patient_id)

    {
      patient: {
        id: patient.id,
        name: patient.display_name,
        status: patient.status,
        status_changed_at: patient.status_changed_at
      },
      medications: patient_medication_stats(patient),
      labs: patient_lab_stats(patient),
      calls: patient_call_stats(patient),
      profile: patient_profile_data(patient)
    }
  end

  private

  # Patient counts by status
  def patient_counts
    {
      total: Patient.count,
      active: Patient.active.count,
      thinkers: Patient.thinkers.count,
      new_leads: Patient.new_leads.count,
      paused: Patient.paused.count,
      cancelled: Patient.cancelled.count
    }
  end

  # Medication statistics
  def medication_stats
    {
      total_active_medications: PatientMedication.active.count,
      overdue: PatientMedication.overdue.count,
      due_soon: PatientMedication.due_soon.count,
      ok: PatientMedication.ok.count,
      declined: PatientMedication.declined.count,
      by_dispensing_method: {
        mail_out: PatientMedication.mail_out.count,
        in_clinic: PatientMedication.in_clinic.count
      }
    }
  end

  # Lab statistics
  def lab_stats
    {
      total_labs: PatientLab.count,
      overdue: PatientLab.overdue.count,
      due_soon: PatientLab.due_soon.count,
      ok: PatientLab.ok.count
    }
  end

  # Call statistics
  def call_stats
    {
      total_pending: PatientCall.pending.count,
      overdue: PatientCall.overdue.count,
      due_today: PatientCall.due_today.count,
      upcoming: PatientCall.upcoming.count,
      by_type: {
        thinker_followup: PatientCall.thinker_followups.pending.count,
        lab_order: PatientCall.lab_orders.pending.count,
        medication_refill: PatientCall.medication_refills.pending.count
      }
    }
  end

  # Appointment statistics
  def appointment_stats
    {
      upcoming: GhlAppointment.upcoming.count,
      confirmed: GhlAppointment.confirmed.upcoming.count,
      without_patient: GhlAppointment.without_patient.upcoming.count,
      recent_synced: GhlAppointment.where('synced_at > ?', 1.hour.ago).count
    }
  end

  # Alert counts for dashboard
  def alert_counts
    {
      overdue_medications: PatientMedication.overdue.count,
      overdue_labs: PatientLab.overdue.count,
      overdue_calls: PatientCall.overdue.count,
      medications_due_soon: PatientMedication.due_soon.count,
      labs_due_soon: PatientLab.due_soon.count,
      calls_due_today: PatientCall.due_today.count
    }
  end

  # Patient-specific medication stats
  def patient_medication_stats(patient)
    medications = patient.patient_medications.active

    {
      total: medications.count,
      overdue: medications.overdue.count,
      due_soon: medications.due_soon.count,
      ok: medications.ok.count,
      list: medications.order(next_order_due: :asc).limit(10).map do |pm|
        {
          id: pm.id,
          medication_name: pm.medication.name,
          dose_per_week: pm.dose_per_week,
          vial_size: pm.vial_size,
          days_supply: pm.days_supply,
          last_order_date: pm.last_order_date,
          next_order_due: pm.next_order_due,
          order_by_date: pm.order_by_date,
          status: pm.status,
          dispensing_method: pm.dispensing_method,
          prepped: pm.prepped
        }
      end
    }
  end

  # Patient-specific lab stats
  def patient_lab_stats(patient)
    labs = patient.patient_labs

    {
      total: labs.count,
      overdue: labs.overdue.count,
      due_soon: labs.due_soon.count,
      ok: labs.ok.count,
      list: labs.order(next_lab_due: :asc).limit(10).map do |lab|
        {
          id: lab.id,
          lab_type: lab.lab_type,
          last_lab_date: lab.last_lab_date,
          next_lab_due: lab.next_lab_due,
          frequency: lab.frequency_description,
          status: lab.status,
          days_until_due: lab.days_until_due
        }
      end
    }
  end

  # Patient-specific call stats
  def patient_call_stats(patient)
    calls = patient.patient_calls.pending

    {
      total_pending: calls.count,
      overdue: calls.overdue.count,
      due_today: calls.due_today.count,
      upcoming: calls.upcoming.count,
      list: calls.order(scheduled_date: :asc).limit(10).map do |call|
        {
          id: call.id,
          call_type: call.call_type,
          call_type_display: call.call_type_display,
          scheduled_date: call.scheduled_date,
          days_until_scheduled: call.days_until_scheduled,
          callable_type: call.callable_type,
          callable_id: call.callable_id
        }
      end
    }
  end

  # Patient profile data
  def patient_profile_data(patient)
    profile = patient.patient_profile

    return nil unless profile

    {
      id: profile.id,
      lead_source: profile.lead_source,
      patient_result: profile.patient_result,
      consult_date: profile.consult_date,
      rate: profile.rate,
      monthly_contract_made: profile.monthly_contract_made,
      annual_contract_made: profile.annual_contract_made,
      discount_id: profile.discount_id,
      discount_name: profile.discount&.name
    }
  end
end
