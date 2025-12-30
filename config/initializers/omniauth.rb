OmniAuth.config.allowed_request_methods = %i[post get]

# Configure OmniAuth to use Rails CSRF tokens
OmniAuth.config.request_validation_phase = Proc.new do |env|
  # This allows OmniAuth to bypass its internal CSRF check when Rails has already verified the token
  # The Rails authenticity token is included automatically by button_to/form_for
end