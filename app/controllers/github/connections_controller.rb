module Github
  class ConnectionsController < ApplicationController
    def create
      repository = current_user.repositories.find(params.expect(:repository_id))

      if Github::ConnectRepositoryService.call(repository.github_installation, repository)
        redirect_to repository_path(repository), notice: 'Repository connected.'
      else
        session[:github_return_repository_id] = repository.id
        redirect_to Github::GetInstallationSettingsUrlService.call(repository.github_installation), allow_other_host: true
      end
    rescue Octokit::Error => e
      Rails.logger.error("GitHub connection failed: #{e.class} - #{e.message}")
      redirect_to repository_path(repository), alert: 'Could not connect to GitHub.'
    end
  end
end
