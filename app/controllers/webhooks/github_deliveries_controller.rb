module Webhooks
  class GithubDeliveriesController < ApplicationController
    skip_before_action :authenticate_user!
    skip_forgery_protection

    def create # rubocop:disable Metrics/AbcSize
      signature = request.headers['X-Hub-Signature-256']
      return head :unauthorized unless Github::VerifyWebhookSignatureService.call(request.raw_post, signature)

      delivery_id = request.headers['X-GitHub-Delivery']
      return head :ok if GithubWebhookDelivery.exists?(delivery_id: delivery_id)

      payload = JSON.parse(request.raw_post)
      delivery = GithubWebhookDelivery.create!(
        delivery_id: delivery_id,
        event_name: request.headers['X-GitHub-Event'],
        action: payload['action'],
        payload: payload
      )

      Github::ProcessWebhookJob.perform_later(delivery.id)

      head :accepted
    rescue JSON::ParserError => e
      Rails.logger.error(e.message)
      head :bad_request
    rescue ActiveRecord::RecordNotUnique => e
      Rails.logger.error(e.message)
      head :ok
    end
  end
end
