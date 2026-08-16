module Callback
  class GithubController < ApplicationController
    def create # rubocop:disable Metrics/AbcSize
      github_installation = Github::FetchInstallation.call(params.expect(:installation_id))
      installation = Github::SaveInstallation.call(current_user, github_installation)
      Github::SyncRepositories.call(installation)

      repository_id = session.delete(:github_return_repository_id)
      return redirect_to repositories_path, notice: 'GitHub repositories synced successfully.' if repository_id.blank?

      repository = current_user.repositories.find(repository_id)
      return redirect_to repository_path(repository), alert: 'Repository limit reached for your current plan.' if Subscriptions::RepositoryLimitReachedService.call(current_user)

      github_repositories = Github::ListRepositories.call(installation)
      has_access = github_repositories.any? { |github_repository| github_repository.id == repository.github_id }

      if has_access
        repository.update!(connected: true, connected_at: Time.current, disconnected_at: nil)
        redirect_to repository_path(repository), notice: 'Repository connected.'
      else
        redirect_to repository_path(repository), alert: 'Repository access was not granted on GitHub.'
      end
    rescue StandardError => e
      Rails.logger.error("GitHub callback failed: #{e.class} - #{e.message}")
      redirect_to repositories_path, alert: 'Could not connect to GitHub. Please try again.'
    end
  end
end
