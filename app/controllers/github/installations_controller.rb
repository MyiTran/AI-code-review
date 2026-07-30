module Github
  class InstallationsController < ApplicationController
    def callback
      github_installation = GithubApp::FetchInstallation.call(params.expect(:installation_id))
      installation = GithubApp::SaveInstallation.call(current_user, github_installation)

      GithubApp::SyncRepositories.call(installation)

      redirect_to repositories_path, notice: 'GitHub repositories synced successfully.'
    rescue Faraday::SSLError => e
      Rails.logger.error("GitHub SSL error: #{e.class} - #{e.message}")
      redirect_to repositories_path, alert: 'Could not connect to GitHub. Please try again.'
    rescue Octokit::Error, ActiveRecord::RecordInvalid, KeyError => e
      Rails.logger.error("GitHub App installation failed: #{e.class} - #{e.message}")
      redirect_to repositories_path, alert: 'Could not sync GitHub repositories.'
    end
  end
end
