require 'rails_helper'

RSpec.describe Github::VerifyWebhookSignatureService do
  let(:payload) { '{"action":"opened"}' }
  let(:secret) { 'webhook-secret' }

  before { allow(ENV).to receive(:fetch).with('GITHUB_WEBHOOK_SECRET').and_return(secret) }

  it 'returns true for valid signature' do
    signature = "sha256=#{OpenSSL::HMAC.hexdigest('SHA256', secret, payload)}"

    expect(described_class.call(payload, signature)).to be(true)
  end

  it 'returns false when signature is blank' do
    expect(described_class.call(payload, nil)).to be(false)
  end

  it 'returns false for invalid signature' do
    expect(described_class.call(payload, 'sha256=wrong')).to be(false)
  end
end
