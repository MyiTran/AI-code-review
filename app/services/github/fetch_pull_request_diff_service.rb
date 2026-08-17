module Github
  class FetchPullRequestDiffService < ApplicationService
    def initialize(pull_request)
      @pull_request = pull_request
    end

    def call
      repository = @pull_request.repository
      token = Github::GenerateInstallationTokenService.call(repository.github_installation.installation_id)
      client = Octokit::Client.new(access_token: token, auto_paginate: true)
      files = client.pull_request_files(repository.full_name, @pull_request.number)

      files.map do |file|
        {
          filename: file.filename,
          status: file.status,
          additions: file.additions,
          deletions: file.deletions,
          patch: file.patch
        }
      end
    end
  end
end
