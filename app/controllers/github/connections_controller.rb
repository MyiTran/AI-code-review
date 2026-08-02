module Github
  class ConnectionsController < ApplicationController
    def create
      repository = current_user.repositories.find(params.expect(:repository_id))

      github_repositories = Github::ListRepositories.call(repository.github_installation)
      has_access = github_repositories.any? { |github_repository| github_repository.id == repository.github_id }

      if has_access
        repository.update!(connected: true, disconnected_at: nil)

        redirect_to repository_path(repository),
          notice: 'Repository connected successfully.',
          status: :see_other
      else
        session[:github_return_repository_id] = repository.id

        redirect_to Github::ManageInstallationUrl.call(repository.github_installation),
          allow_other_host: true
      end
    rescue Octokit::Error => e
      Rails.logger.error("GitHub connection failed: #{e.class} - #{e.message}")

      redirect_to repository_path(repository),
        alert: 'Could not connect to GitHub.',
        status: :see_other
    end
  end
end
