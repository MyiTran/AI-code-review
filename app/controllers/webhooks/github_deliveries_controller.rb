module Webhooks
  class GithubDeliveriesController < ApplicationController
    skip_before_action :authenticate_user!
    skip_forgery_protection

    def create
      payload_body = request.raw_post
      signature = request.headers['X-Hub-Signature-256']

      return head :unauthorized unless Github::VerifyWebhookSignature.call(payload_body, signature)

      delivery_id = request.headers['X-GitHub-Delivery']
      return head :ok if GithubWebhookDelivery.exists?(delivery_id: delivery_id)

      payload = JSON.parse(payload_body)

      delivery = GithubWebhookDelivery.create!(
        delivery_id: delivery_id,
        event_name: request.headers['X-GitHub-Event'],
        action: payload['action'],
        payload: payload
      )

      Github::SyncPullRequest.call(delivery)

      head :accepted
    rescue JSON::ParserError
      head :bad_request
    rescue ActiveRecord::RecordNotUnique
      head :ok
    end
  end
end
