require 'rails_helper'

RSpec.describe Github::FetchInstallationService do
  describe '.call', :vcr do
    it 'fetches installation from GitHub' do
      installation_id = ENV.fetch('TEST_GITHUB_INSTALLATION_ID')

      installation = described_class.call(installation_id)

      expect(installation.id).to eq(installation_id.to_i)
      expect(installation.account).to be_present
      expect(installation.repository_selection).to be_present
    end
  end
end
