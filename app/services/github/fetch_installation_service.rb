module Github
  class FetchInstallationService < ApplicationService
    def initialize(installation_id)
      @installation_id = installation_id
      @client = Octokit::Client.new(bearer_token: Github::GenerateJwtService.call)
    end

    def call
      @client.installation(installation_id)
    end

    private

    attr_reader :installation_id, :client
  end
end
