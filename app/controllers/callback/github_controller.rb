module Callback
  class GithubController < ApplicationController
    def create
      github_installation = Github::FetchInstallationService.call(params.expect(:installation_id))
      installation = Github::SaveInstallationService.call(current_user, github_installation)

      Github::SyncRepositoriesService.call(installation)
      handle_repository_connection(installation)
    rescue StandardError => e
      Rails.logger.error("GitHub callback failed: #{e.class} - #{e.message}")
      redirect_to repositories_path, alert: 'Could not connect to GitHub. Please try again.'
    end

    private

    def handle_repository_connection(installation)
      repository_id = session.delete(:github_return_repository_id)
      return redirect_to repositories_path, notice: 'GitHub repositories synced successfully.' if repository_id.blank?

      repository = current_user.repositories.find(repository_id)
      return redirect_to repository_path(repository), alert: 'Repository limit reached for your current plan.' if Subscriptions::RepositoryLimitReachedService.call(current_user)

      verify_and_connect_repository(installation, repository)
    end

    def verify_and_connect_repository(installation, repository)
      if Github::ConnectRepositoryService.call(installation, repository)
        redirect_to repository_path(repository), notice: 'Repository connected.'
      else
        redirect_to repository_path(repository), alert: 'Repository access was not granted on GitHub.'
      end
    end
  end
end
