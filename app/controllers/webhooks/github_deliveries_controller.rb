module Webhooks
  class GithubDeliveriesController < ApplicationController
    skip_before_action :authenticate_user!
    skip_forgery_protection

    def create
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

      Github::SyncPullRequestService.call(delivery)
      head :accepted
    rescue JSON::ParserError
      head :bad_request
    rescue ActiveRecord::RecordNotUnique
      head :ok
    end
  end
end
