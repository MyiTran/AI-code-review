module Github
  class SyncRepositoriesService < ApplicationService
    def initialize(installation)
      @installation = installation
    end

    def call
      github_repositories = Github::ListRepositoriesService.call(installation)
      repositories_by_github_id = installation.repositories.index_by(&:github_id)

      update_existing_repositories(github_repositories, repositories_by_github_id)
      sync_status = save_new_repositories(github_repositories, repositories_by_github_id)
      mark_disconnected_repositories(github_repositories)

      {
        repositories: installation.repositories.reload,
        repository_limit_reached: sync_status == :limit_reached
      }
    end

    private

    attr_reader :installation

    def update_existing_repositories(github_repositories, repositories_by_github_id)
      github_repositories.each do |github_repository|
        repository = repositories_by_github_id[github_repository.id]
        repository&.update!(repository_attributes(github_repository))
      end
    end

    def save_new_repositories(github_repositories, repositories_by_github_id)
      new_repositories = github_repositories.reject { |github_repository| repositories_by_github_id.key?(github_repository.id) }
      repositories_to_save = new_repositories.sort_by(&:full_name).first(remaining_repository_slots)

      repositories_to_save.each { |github_repository| create_repository(github_repository) }
      Subscriptions::ClearUsageCacheService.call(installation.user) if repositories_to_save.any?

      new_repositories.size > repositories_to_save.size ? :limit_reached : :success
    end

    def remaining_repository_slots
      repository_count = Subscriptions::RepositoriesCountService.call(installation.user).to_i
      repository_limit = Subscriptions::GetPlanLimitsService.call(installation.user).fetch(:repositories).to_i

      [repository_limit - repository_count, 0].max
    end

    def create_repository(github_repository)
      installation.repositories.create!(
        repository_attributes(github_repository).merge(
          connected: true,
          connected_at: Time.current,
          disconnected_at: nil
        )
      )
    end

    def repository_attributes(github_repository)
      {
        github_id: github_repository.id,
        name: github_repository.name,
        full_name: github_repository.full_name,
        description: github_repository.description,
        language: github_repository.language,
        visibility: github_repository.visibility,
        default_branch: github_repository.default_branch,
        github_url: github_repository.html_url
      }
    end

    def mark_disconnected_repositories(github_repositories)
      github_ids = github_repositories.map(&:id)
      current_time = Time.current

      installation.repositories.where(connected: true).where.not(github_id: github_ids).update_all( # rubocop:disable Rails/SkipsModelValidations
        connected: false,
        auto_review_enabled: false,
        disconnected_at: current_time,
        updated_at: current_time
      )
    end
  end
end
