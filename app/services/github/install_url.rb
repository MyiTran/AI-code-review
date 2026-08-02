module Github
  class InstallUrl
    def self.call
      "https://github.com/apps/#{ENV.fetch('GITHUB_APP_SLUG')}/installations/new"
    end
  end
end
