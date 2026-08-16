module Github
  class FetchCommitAuthorService < ApplicationService
    def initialize(pull_request, commit_sha)
      @pull_request = pull_request
      @commit_sha = commit_sha
    end

    def call
      repository = pull_request.repository
      token = Github::InstallationToken.call(repository.github_installation.installation_id)
      commit = Octokit::Client.new(access_token: token).commit(repository.full_name, commit_sha)

      commit.author&.login || commit.commit.author.name
    end

    private

    attr_reader :pull_request, :commit_sha
  end
end
