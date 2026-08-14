module Github
  class VerifyWebhookSignatureService < ApplicationService
    def initialize(payload, signature)
      @payload = payload
      @signature = signature
    end

    def call
      return false if signature.blank?

      secret = ENV.fetch('GITHUB_WEBHOOK_SECRET')
      digest = OpenSSL::HMAC.hexdigest('SHA256', secret, payload)
      expected_signature = "sha256=#{digest}"

      return false unless signature.bytesize == expected_signature.bytesize

      ActiveSupport::SecurityUtils.secure_compare(signature, expected_signature)
    end

    private

    attr_reader :payload, :signature
  end
end
