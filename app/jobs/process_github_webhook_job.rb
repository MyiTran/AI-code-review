class ProcessGithubWebhookJob < ApplicationJob
  queue_as :default

  def perform(delivery_id)
    delivery = GithubWebhookDelivery.find(delivery_id)

    delivery.processing!

    Github::SyncPullRequest.call(delivery)

    delivery.processed!
  rescue StandardError => e
    delivery.presence&.failed!

    Rails.logger.error(e.message)

    raise
  end
end
