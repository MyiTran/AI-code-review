module Github
  class SyncRepositoriesService < ApplicationService
    def initialize(installation)
      @installation = installation
    end

    def call
      github_repositories = Github::ListRepositoriesService.call(installation)

      github_repositories.each { |github_repository| save_repository(github_repository) }

      mark_disconnected_repositories(github_repositories)

      installation.repositories.reload
    end

    private

    attr_reader :installation

    def save_repository(github_repository)
      repository = installation.repositories.find_or_initialize_by(github_id: github_repository.id)
      new_repository = repository.new_record?

      repository.assign_attributes(
        name: github_repository.name,
        full_name: github_repository.full_name,
        description: github_repository.description,
        language: github_repository.language,
        visibility: github_repository.visibility,
        default_branch: github_repository.default_branch,
        github_url: github_repository.html_url
      )

      connect_new_repository(repository, installation.user) if new_repository
      repository.save!
    end

    def connect_new_repository(repository, user)
      return if Subscriptions::RepositoryLimitReachedService.call(user)

      repository.connected = true
      repository.connected_at = Time.current
      repository.disconnected_at = nil
    end

    def mark_disconnected_repositories(github_repositories)
      connected_github_ids = github_repositories.map(&:id)
      current_time = Time.current

      installation.repositories.where(connected: true).where.not(github_id: connected_github_ids).update_all( # rubocop:disable Rails/SkipsModelValidations
        connected: false,
        disconnected_at: current_time,
        updated_at: current_time
      )
    end
  end
end
