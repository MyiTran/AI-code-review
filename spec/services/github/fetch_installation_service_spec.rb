require 'rails_helper'

RSpec.describe Github::FetchInstallationService do
  describe '.call' do
    subject(:fetch_installation) do
      described_class.call(installation_id)
    end

    let(:installation_id) do
      ENV.fetch('TEST_GITHUB_INSTALLATION_ID', '155385740')
    end

    before do
      allow(Github::GenerateJwtService)
        .to receive(:call)
        .and_return('test-jwt')
    end

    it 'fetches installation from GitHub', vcr: true do
      installation = fetch_installation

      expect(installation.id).to eq(installation_id.to_i)
      expect(installation.account.login).to be_present
      expect(installation.repository_selection).to be_present
    end
  end
end
