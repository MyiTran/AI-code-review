module Github
  class SyncPullRequestService < ApplicationService
    EVENT_NAME = 'pull_request'.freeze
    ACTIONS = ['opened', 'synchronize', 'closed', 'reopened'].freeze

    def initialize(delivery)
      @delivery = delivery
    end

    def call # rubocop:disable Metrics/AbcSize
      return unless delivery.event_name == EVENT_NAME
      return unless ACTIONS.include?(delivery.action)

      payload = delivery.payload
      repository = Repository.find_by!(github_id: payload.dig('repository', 'id'))
      github_pull_request = payload.fetch('pull_request')
      pull_request = repository.pull_requests.find_or_initialize_by(github_id: github_pull_request.fetch('id'))

      return if pull_request.new_record? && pull_request_limit_reached?(repository)

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
    rescue ActiveRecord::RecordNotFound, ActiveRecord::RecordInvalid, KeyError => e
      Rails.logger.error("Failed to sync pull request: #{e.message}")
      raise
    end

    private

    attr_reader :delivery

    def pull_request_limit_reached?(repository)
      Subscriptions::PullRequestLimitReachedService.call(repository.github_installation.user)
    end
  end
end
