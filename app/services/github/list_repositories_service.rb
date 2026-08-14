module Github
  class ListRepositoriesService < ApplicationService
    def initialize(installation)
      @installation = installation
    end

    def call
      response = client.get('/installation/repositories')

      response.repositories
    end

    private

    attr_reader :installation

    def client
      token = Github::GenerateInstallationTokenService.call(installation.installation_id)

      Octokit::Client.new(access_token: token, auto_paginate: true)
    end
  end
end
