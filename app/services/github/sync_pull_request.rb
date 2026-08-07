module Github
  class SyncPullRequest
    ACTIONS = ['opened', 'synchronize', 'closed', 'reopened'].freeze

    def self.call(delivery)
      return unless delivery.event_name == 'pull_request'
      return unless ACTIONS.include?(delivery.action)

      payload = delivery.payload
      repository = Repository.find_by!(github_id: payload.dig('repository', 'id'))
      github_pull_request = payload.fetch('pull_request')

      pull_request = repository.pull_requests.find_or_initialize_by(github_id: github_pull_request.fetch('id'))

      pull_request.update!(
        number: github_pull_request.fetch('number'),
        title: github_pull_request.fetch('title'),
        author: github_pull_request.dig('user', 'login'),
        state: github_pull_request.fetch('state'),
        source_branch: github_pull_request.dig('head', 'ref'),
        target_branch: github_pull_request.dig('base', 'ref'),
        head_commit_sha: github_pull_request.dig('head', 'sha'),
        github_url: github_pull_request.fetch('html_url'),
        opened_at: github_pull_request.fetch('created_at'),
        closed_at: github_pull_request['closed_at'],
        merged_at: github_pull_request['merged_at']
      )

      pull_request
    end
  end
end
