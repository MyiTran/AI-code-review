module GithubApp
  class ManageInstallationUrl
    def self.call(installation)
      if installation.account_type == 'Organization'
        "https://github.com/organizations/#{installation.account_login}/settings/installations/#{installation.installation_id}"
      else
        "https://github.com/settings/installations/#{installation.installation_id}"
      end
    end
  end
end
