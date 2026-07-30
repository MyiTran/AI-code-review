module GithubApp
  class SyncRepositories
    def self.call(installation)
      repositories = GithubApp::ListRepositories.call(installation)

      repositories.each do |github_repository|
        save_repository(installation, github_repository)
      end
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
        connected_at: repository.connected_at || Time.current
      )

      repository.save!
    end

    private_class_method :save_repository
  end
end
