class GhlApiService
  include HTTParty
  base_uri ENV.fetch('GHL_API_URL', 'https://rest.gohighlevel.com/v1')

  def initialize
    @api_key = ENV['GHL_API_KEY']
    @location_id = ENV['GHL_LOCATION_ID']
    raise 'GHL_API_KEY environment variable not set' if @api_key.blank?
    raise 'GHL_LOCATION_ID environment variable not set' if @location_id.blank?
  end

  # Fetch appointments from GoHighLevel
  def fetch_appointments(start_date: nil, end_date: nil)
    params = {
      locationId: @location_id
    }
    params[:startDate] = start_date.to_time.iso8601 if start_date.present?
    params[:endDate] = end_date.to_time.iso8601 if end_date.present?

    response = self.class.get('/appointments', {
      headers: headers,
      query: params
    })

    handle_response(response)
  end

  # Fetch a single appointment by ID
  def fetch_appointment(appointment_id)
    response = self.class.get("/appointments/#{appointment_id}", {
      headers: headers
    })

    handle_response(response)
  end

  # Fetch contact by ID
  def fetch_contact(contact_id)
    response = self.class.get("/contacts/#{contact_id}", {
      headers: headers
    })

    handle_response(response)
  end

  # Search contacts by email
  def search_contacts_by_email(email)
    response = self.class.get('/contacts', {
      headers: headers,
      query: {
        locationId: @location_id,
        email: email
      }
    })

    handle_response(response)
  end

  # Search contacts by phone
  def search_contacts_by_phone(phone)
    response = self.class.get('/contacts', {
      headers: headers,
      query: {
        locationId: @location_id,
        phone: phone
      }
    })

    handle_response(response)
  end

  # Create a contact
  def create_contact(contact_data)
    response = self.class.post('/contacts', {
      headers: headers,
      body: contact_data.merge(locationId: @location_id).to_json
    })

    handle_response(response)
  end

  # Update a contact
  def update_contact(contact_id, contact_data)
    response = self.class.put("/contacts/#{contact_id}", {
      headers: headers,
      body: contact_data.to_json
    })

    handle_response(response)
  end

  private

  def headers
    {
      'Authorization' => "Bearer #{@api_key}",
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end

  def handle_response(response)
    case response.code
    when 200..299
      JSON.parse(response.body) rescue response.body
    when 401
      raise 'GHL API authentication failed - check your API key'
    when 404
      nil
    when 429
      raise 'GHL API rate limit exceeded - try again later'
    else
      raise "GHL API error: #{response.code} - #{response.body}"
    end
  end
end
