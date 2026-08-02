module Github
  class InstallationToken
    def self.call(installation_id)
      client.create_app_installation_access_token(installation_id).token
    end

    def self.client
      Octokit::Client.new(bearer_token: Github::GenerateJwt.call)
    end

    private_class_method :client
  end
end
