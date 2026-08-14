module Github
  class GetInstallationSettingsUrlService < ApplicationService
    def initialize(installation)
      @installation = installation
    end

    def call
      if installation.account_type == 'Organization'
        "https://github.com/organizations/#{installation.account_login}/settings/installations/#{installation.installation_id}"
      else
        "https://github.com/settings/installations/#{installation.installation_id}"
      end
    end

    private

    attr_reader :installation
  end
end
