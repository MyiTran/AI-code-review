module Github
  class ListRepositories
    def self.call(installation)
      token = Github::InstallationToken.call(installation.installation_id)
      client = Octokit::Client.new(access_token: token, auto_paginate: true)
      response = client.get('/installation/repositories')
      response.repositories
    end
  end
end
