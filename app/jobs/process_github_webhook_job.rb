class ProcessGithubWebhookJob
  include Sidekiq::Job

  sidekiq_options queue: :default
  def perform(delivery_id)
    delivery = GithubWebhookDelivery.find(delivery_id)

    delivery.processing!
    Github::SyncPullRequestService.call(delivery)
    delivery.update!(status: :processed, processed_at: Time.current)
  rescue StandardError => e
    delivery.presence&.failed!

    Rails.logger.error(e.message)
    raise
  end
end
