module GithubApp
  class ListRepositories
    def self.call(installation)
      token = GithubApp::InstallationToken.call(installation.installation_id)
      client = Octokit::Client.new(access_token: token, auto_paginate: true)
      response = client.get('/installation/repositories')
      response.repositories
    end
  end
end
