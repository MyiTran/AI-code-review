require 'rails_helper'

RSpec.describe Github::FetchInstallationService do
  describe '.call' do
    subject(:fetch_installation) { described_class.call(installation_id) }

    let(:installation_id) { ENV.fetch('TEST_GITHUB_INSTALLATION_ID') }

    it 'fetches installation from GitHub', vcr: true do
      installation = fetch_installation

      expect(installation.id).to eq(installation_id.to_i)
      expect(installation.account.login).to be_present
      expect(installation.repository_selection).to be_present
    end
  end
end
