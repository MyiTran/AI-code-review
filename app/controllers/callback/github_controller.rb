module Callback
  class GithubController < ApplicationController
    def create
      github_installation = Github::FetchInstallationService.call(params.expect(:installation_id))
      installation = Github::SaveInstallationService.call(current_user, github_installation)
      result = Github::SyncRepositoriesService.call(installation)

      handle_repository_connection(installation, result[:repository_limit_reached])
    rescue StandardError => e
      Rails.logger.error("GitHub callback failed: #{e.class} - #{e.message}")
      redirect_to repositories_path, alert: 'Could not connect to GitHub. Please try again.'
    end

    private

    def handle_repository_connection(installation, repository_limit_reached)
      repository_id = session.delete(:github_return_repository_id)
      return redirect_to repositories_path, notice: sync_message(repository_limit_reached) if repository_id.blank?

      repository = current_user.repositories.find_by(id: repository_id)
      return redirect_to repositories_path, alert: 'Repository not found.' if repository.blank?

      verify_and_connect_repository(installation, repository)
    end

    def verify_and_connect_repository(installation, repository)
      if Github::ConnectRepositoryService.call(installation, repository)
        redirect_to repository_path(repository), notice: 'Repository connected.'
      else
        redirect_to repository_path(repository), alert: 'Repository access was not granted on GitHub.'
      end
    end

    def sync_message(repository_limit_reached)
      return 'GitHub repositories synced successfully.' unless repository_limit_reached

      'GitHub repositories synced. Some repositories were not added because your repository limit was reached.'
    end
  end
end
