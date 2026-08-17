class ProcessGithubWebhookJob
  include Sidekiq::Job

  sidekiq_options queue: :default
  def perform(delivery_id)
    delivery = GithubWebhookDelivery.find(delivery_id)

    delivery.processing!
    Github::SyncPullRequestService.call(delivery)
    delivery.processed!
  rescue StandardError => e
    delivery.presence&.failed!

    Rails.logger.error(e.message)
    raise
  end
end
