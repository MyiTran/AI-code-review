module Github
  class FetchInstallation
    def self.call(installation_id)
      client.installation(installation_id)
    end

    def self.client
      Octokit::Client.new(bearer_token: Github::GenerateJwt.call)
    end

    private_class_method :client
  end
end
