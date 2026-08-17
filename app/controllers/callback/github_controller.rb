module Callback
  class GithubController < ApplicationController
    def create
      github_installation = Github::FetchInstallationService.call(params.expect(:installation_id))
      installation = Github::SaveInstallationService.call(current_user, github_installation)

      Github::SyncRepositoriesService.call(installation)

      redirect_to return_path, notice: 'GitHub repositories synced successfully.'
    rescue StandardError => e
      Rails.logger.error("GitHub SSL error: #{e.class} - #{e.message}")
      redirect_to repositories_path, alert: 'Could not connect to GitHub. Please try again.'
    end

    private

    def return_path
      repository_id = session.delete(:github_return_repository_id)
      repository = current_user.repositories.find_by(id: repository_id)

      if repository
        repository_path(repository)
      else
        repositories_path
      end
    end
  end
end
