module GithubHelper
  def github_app_installation_url
    "https://github.com/apps/#{ENV.fetch('GITHUB_APP_SLUG')}/installations/new"
  end
end
