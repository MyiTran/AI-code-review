module Github
  class VerifyWebhookSignature
    def self.call(payload, signature)
      return false if signature.blank?

      secret = ENV.fetch('GITHUB_WEBHOOK_SECRET')
      digest = OpenSSL::HMAC.hexdigest('SHA256', secret, payload)
      expected_signature = "sha256=#{digest}"

      return false unless signature.bytesize == expected_signature.bytesize

      ActiveSupport::SecurityUtils.secure_compare(signature, expected_signature)
    end
  end
end
