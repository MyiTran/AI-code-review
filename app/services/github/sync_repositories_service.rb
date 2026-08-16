module Github
  class SyncRepositories
    def self.call(installation)
      github_repositories = Github::ListRepositories.call(installation)

      github_repositories.each { |github_repository| save_repository(installation, github_repository) }
      mark_disconnected_repositories(installation, github_repositories)

      installation.repositories.reload
    end

    def self.save_repository(installation, github_repository)
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

    def self.connect_new_repository(repository, user)
      return if Subscriptions::RepositoryLimitReachedService.call(user)

      repository.connected = true
      repository.connected_at = Time.current
      repository.disconnected_at = nil
    end

    def self.mark_disconnected_repositories(installation, github_repositories)
      github_ids = github_repositories.map(&:id)
      current_time = Time.current

      installation.repositories.where(connected: true).where.not(github_id: github_ids).update_all(connected: false, disconnected_at: current_time, updated_at: current_time) # rubocop:disable Rails/SkipsModelValidations
    end

    private_class_method :save_repository, :connect_new_repository, :mark_disconnected_repositories
  end
end
