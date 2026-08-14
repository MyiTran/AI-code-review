module Github
  class GenerateInstallationTokenService < ApplicationService
    def initialize(installation_id)
      @installation_id = installation_id
      @client = Octokit::Client.new(bearer_token: Github::GenerateJwtService.call)
    end

    def call
      response = client.create_app_installation_access_token(installation_id)

      response.token
    end

    private

    attr_reader :installation_id, :client
  end
end
