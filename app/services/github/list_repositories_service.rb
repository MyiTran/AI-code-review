module Github
  class ListRepositoriesService < ApplicationService
    def initialize(installation)
      @installation = installation
      token = Github::GenerateInstallationTokenService.call(installation.installation_id)
      @client = Octokit::Client.new(access_token: token, auto_paginate: true)
    end

    def call
      response = client.get('/installation/repositories')

      response.repositories
    end

    private

    attr_reader :installation, :client
  end
end
