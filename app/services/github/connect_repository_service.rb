module Github
  class ConnectRepositoryService < ApplicationService
    def initialize(installation, repository)
      @installation = installation
      @repository = repository
    end

    def call
      github_repositories = Github::ListRepositoriesService.call(installation)
      has_access = github_repositories.any? { |github_repo| github_repo.id == repository.github_id }

      if has_access
        repository.update!(connected: true, connected_at: Time.current, disconnected_at: nil)
        true
      else
        false
      end
    end

    private

    attr_reader :installation, :repository
  end
end
