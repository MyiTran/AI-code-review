module Github
  class GenerateJwtService < ApplicationService
    def call
      JWT.encode(payload, private_key, 'RS256')
    end

    private

    def payload
      now = Time.current.to_i
      { iat: now - 60, exp: now + 9.minutes.to_i, iss: ENV.fetch('GITHUB_APP_ID') }
    end

    def private_key
      key_content = ENV.fetch('GITHUB_APP_PRIVATE_KEY').to_s.gsub('\\n', "\n")

      OpenSSL::PKey::RSA.new(key_content)
    end
  end
end
