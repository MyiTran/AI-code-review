module Github
  class ProcessWebhookJob
    include Sidekiq::Job

    REVIEW_ACTIONS = ['opened', 'synchronize'].freeze

    sidekiq_options queue: :default
    def perform(delivery_id)
      delivery = GithubWebhookDelivery.find(delivery_id)
      delivery.processing!

      pull_request = Github::SyncPullRequest.call(delivery)
      Reviews::Generate.call(pull_request) if review_required?(delivery, pull_request)

      delivery.processed!
    rescue StandardError => e
      delivery&.failed!
      Rails.logger.error("GitHub webhook processing failed: #{e.class} - #{e.message}")
      raise
    end

    private

    def review_required?(delivery, pull_request)
      pull_request.present? && REVIEW_ACTIONS.include?(delivery.action) && pull_request.repository.auto_review_enabled?
    end
  end
end
