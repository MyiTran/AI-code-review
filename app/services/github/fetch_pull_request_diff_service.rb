module Github
  class FetchPullRequestDiffService < ApplicationService
    def initialize(pull_request, base_sha: nil, head_sha: nil)
      @pull_request = pull_request
      @base_sha = base_sha
      @head_sha = head_sha
    end

    def call
      repository = pull_request.repository
      token = Github::GenerateInstallationTokenService.call(repository.github_installation.installation_id)
      client = Octokit::Client.new(access_token: token, auto_paginate: true)

      files =
        if base_sha.present? && head_sha.present?
          client.compare(repository.full_name, base_sha, head_sha).files
        else
          client.pull_request_files(repository.full_name, pull_request.number)
        end

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

    private

    attr_reader :pull_request, :base_sha, :head_sha
  end
end
