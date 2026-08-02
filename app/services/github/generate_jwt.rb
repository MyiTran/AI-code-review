module Github
  class GenerateJwt
    def self.call
      new.call
    end

    def call
      private_key = OpenSSL::PKey::RSA.new(File.read(private_key_path))
      JWT.encode(payload, private_key, 'RS256')
    end

    private

    def payload
      now = Time.current.to_i
      { iat: now - 60, exp: now + 9.minutes.to_i, iss: ENV.fetch('GITHUB_APP_ID') }
    end

    def private_key_path
      Rails.root.join(ENV.fetch('GITHUB_APP_PRIVATE_KEY_PATH'))
    end
  end
end
