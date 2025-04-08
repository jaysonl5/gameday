class OauthTokenService
  class ServiceUnavailableError < StandardError; end

  MAX_RETRIES = 3
  RETRY_DELAY = 5

  def self.fetch_token
    new.fetch_token
  end

  def fetch_token
    retries = 0

    begin
      consumer = create_consumer

      request_token = consumer.get_request_token(
        oauth_callback: ENV['MX_CALLBACK_URL']
      )
      Rails.logger.info("Request Token: #{request_token}")
      access_token = request_token.get_access_token
      Rails.logger.info("Access Token: #{access_token}")
      return access_token
    rescue OAuth::Unauthorized, Net::HTTPServiceUnavailable => e
      retries += 1
      if retries <= MAX_RETRIES
        Rails.logger.warn("Retrying to fetch token (attempt #{retries}): #{e.message}")
        sleep(RETRY_DELAY * retries)
        retry
      else
        Rails.logger.error("Failed to fetch token after #{MAX_RETRIES} attempts: #{e.message}")
        raise ServiceUnavailableError, "Failed to fetch token: #{e.message}"
      end
    end
  end

  private

  def create_consumer
    OAuth::Consumer.new(
      ENV['MX_CONSUMER_KEY'],
      ENV['MX_CONSUMER_SECRET'],
      {
        site: ENV['MX_BASE_URL'],
        request_token_path: '/checkout/v3/oauth/1a/requesttoken',
        access_token_path: '/checkout/v3/oauth/1a/accesstoken',
        scheme: :header
      }
    )
  end
end