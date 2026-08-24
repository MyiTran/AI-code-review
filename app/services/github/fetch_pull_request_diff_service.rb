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
      files = fetch_files(client, repository)

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

    def fetch_files(client, repository)
      return pull_request_files(client, repository) if base_sha.blank? || head_sha.blank?

      comparison = client.compare(repository.full_name, base_sha, head_sha)

      if comparison.status == 'ahead'
        comparison.files
      else
        pull_request_files(client, repository)
      end
    rescue Octokit::NotFound, Octokit::UnprocessableEntity
      pull_request_files(client, repository)
    end

    def pull_request_files(client, repository)
      client.pull_request_files(repository.full_name, pull_request.number)
    end
  end
end
