module Github
  class SyncRepositories
    def self.call(installation)
      github_repositories = Github::ListRepositories.call(installation)

      github_repositories.each do |github_repository|
        save_repository(installation, github_repository)
      end

      mark_disconnected_repositories(installation, github_repositories)

      installation.repositories.reload
    end

    def self.save_repository(installation, github_repository)
      repository = installation.repositories.find_or_initialize_by(github_id: github_repository.id)

      repository.assign_attributes(
        name: github_repository.name,
        full_name: github_repository.full_name,
        description: github_repository.description,
        language: github_repository.language,
        visibility: github_repository.visibility,
        default_branch: github_repository.default_branch,
        github_url: github_repository.html_url,
        connected_at: connected_at_for(repository),
        connected: true,
        disconnected_at: nil
      )

      repository.save!
    end

    def self.connected_at_for(repository)
      if repository.new_record? || !repository.connected?
        Time.current
      else
        repository.connected_at
      end
    end

    def self.mark_disconnected_repositories(installation, github_repositories)
      connected_github_ids = github_repositories.map(&:id)
      current_time = Time.current

      installation.repositories.where(connected: true).where.not(github_id: connected_github_ids).update_all( # rubocop:disable Rails/SkipsModelValidations
        connected: false,
        disconnected_at: current_time,
        updated_at: current_time
      )
    end

    private_class_method :save_repository
    private_class_method :mark_disconnected_repositories
  end
end
