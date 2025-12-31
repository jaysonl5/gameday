class GhlSyncService
  def initialize
    @api_service = GhlApiService.new
  end

  # Sync appointments from GoHighLevel
  def sync_appointments(start_date: 30.days.ago, end_date: 30.days.from_now)
    log = GhlSyncLog.start_sync('appointments')

    begin
      appointments_data = @api_service.fetch_appointments(
        start_date: start_date,
        end_date: end_date
      )

      return log.mark_failed!('No appointments data returned') if appointments_data.blank?

      appointments = appointments_data.is_a?(Hash) ? appointments_data['appointments'] : appointments_data
      return log.mark_failed!('No appointments array in response') if appointments.blank?

      appointments.each do |appointment_data|
        process_appointment(appointment_data, log)
      end

      if log.records_failed > 0
        log.mark_partial!
      else
        log.mark_success!
      end

      log
    rescue StandardError => e
      log.mark_failed!(e)
      raise
    end
  end

  # Auto-create patients from confirmed consult appointments
  def auto_create_patients_from_appointments
    appointments = GhlAppointment.where(
      patient_id: nil,
      appointment_status: 'confirmed',
      appointment_type: 'consult'
    ).where('scheduled_at >= ?', Time.current)

    created_count = 0

    appointments.each do |appointment|
      next if appointment.ghl_contact_id.blank?

      begin
        contact_data = @api_service.fetch_contact(appointment.ghl_contact_id)
        next if contact_data.blank?

        patient = create_patient_from_contact(contact_data, appointment)

        if patient
          appointment.update!(patient: patient, patient_created: true)
          created_count += 1
        end
      rescue StandardError => e
        Rails.logger.error("Failed to create patient from appointment #{appointment.id}: #{e.message}")
      end
    end

    created_count
  end

  private

  def process_appointment(appointment_data, log)
    log.increment_processed!

    ghl_appointment_id = appointment_data['id']
    return log.increment_failed! if ghl_appointment_id.blank?

    appointment = GhlAppointment.find_or_initialize_by(
      ghl_appointment_id: ghl_appointment_id
    )

    is_new = appointment.new_record?

    appointment.assign_attributes(
      ghl_calendar_id: appointment_data['calendarId'],
      appointment_status: map_appointment_status(appointment_data['status']),
      scheduled_at: parse_datetime(appointment_data['startTime']),
      end_time: parse_datetime(appointment_data['endTime']),
      appointment_type: appointment_data['appointmentType'] || 'unknown',
      notes: appointment_data['notes'],
      synced_at: Time.current
    )

    # Try to find patient by contact ID
    if appointment_data['contactId'].present?
      patient = Patient.find_by(ghl_contact_id: appointment_data['contactId'])
      appointment.patient = patient if patient
    end

    if appointment.save
      is_new ? log.increment_created! : log.increment_updated!
    else
      log.increment_failed!
    end
  rescue StandardError => e
    Rails.logger.error("Failed to process appointment #{ghl_appointment_id}: #{e.message}")
    log.increment_failed!
  end

  def create_patient_from_contact(contact_data, appointment)
    # Check if patient already exists by GHL contact ID
    existing_patient = Patient.find_by(ghl_contact_id: contact_data['id'])
    return existing_patient if existing_patient

    # Extract contact info
    email = contact_data['email']
    phone = contact_data['phone']
    name = [contact_data['firstName'], contact_data['lastName']].compact.join(' ')

    # Create patient
    patient = Patient.new(
      name: name,
      email: email,
      phone: phone,
      status: 'new_lead',
      ghl_contact_id: contact_data['id']
    )

    if patient.save
      # Create patient profile
      patient.create_patient_profile!(
        consult_date: appointment.scheduled_at&.to_date,
        patient_result: 'Thinker', # Default for upcoming consults
        lead_source: contact_data['source'] || 'GoHighLevel'
      )

      patient
    else
      Rails.logger.error("Failed to create patient from contact: #{patient.errors.full_messages}")
      nil
    end
  end

  def map_appointment_status(ghl_status)
    case ghl_status&.downcase
    when 'confirmed' then 'confirmed'
    when 'cancelled' then 'cancelled'
    when 'showed' then 'completed'
    when 'noshow', 'no_show' then 'no_show'
    when 'rescheduled' then 'rescheduled'
    else 'confirmed' # Default
    end
  end

  def parse_datetime(datetime_string)
    return nil if datetime_string.blank?
    Time.zone.parse(datetime_string) rescue nil
  end
end
