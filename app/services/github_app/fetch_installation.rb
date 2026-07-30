module GithubApp
  class FetchInstallation
    def self.call(installation_id)
      client.installation(installation_id)
    end

    def self.client
      Octokit::Client.new(bearer_token: GithubApp::GenerateJwt.call)
    end

    private_class_method :client
  end
end
