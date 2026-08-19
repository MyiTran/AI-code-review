module Github
  class ProcessWebhookJob
    include Sidekiq::Job

    REVIEW_ACTIONS = ['opened', 'synchronize'].freeze

    sidekiq_options queue: :default, retry: 3

    def perform(delivery_id)
      delivery = GithubWebhookDelivery.find(delivery_id)
      delivery.processing!

      pull_request = Github::SyncPullRequestService.call(delivery)
      Realtime::BroadcastPullRequestService.call(pull_request) if pull_request.present?

      enqueue_review(pull_request) if review_required?(delivery, pull_request)

      delivery.processed!
    rescue StandardError => e
      delivery&.failed!
      Rails.logger.error("GitHub webhook processing failed: #{e.class} - #{e.message}")
      raise
    end

    private

    def enqueue_review(pull_request)
      ai_model = pull_request.repository.ai_model || AiModel.find_by!(is_default: true, active: true)
      review = find_or_create_review(pull_request, ai_model)

      Realtime::BroadcastReviewService.call(review)
      Reviews::GenerateJob.perform_async(review.id)
    end

    def find_or_create_review(pull_request, ai_model)
      review = pull_request.reviews.find_or_initialize_by(commit_sha: pull_request.head_commit_sha, ai_model: ai_model)
      return review if review.persisted?

      review.base_commit_sha = previous_commit_sha(pull_request)
      review.status = 'processing'
      review.save!
      review
    end

    def previous_commit_sha(pull_request)
      pull_request.reviews.where(status: 'completed').order(created_at: :desc).pick(:commit_sha)
    end

    def review_required?(delivery, pull_request)
      pull_request.present? && REVIEW_ACTIONS.include?(delivery.action) && pull_request.repository.auto_review_enabled?
    end
  end
end
