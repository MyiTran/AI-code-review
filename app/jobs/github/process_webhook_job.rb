module Github
  class ProcessWebhookJob
    include Sidekiq::Job

    sidekiq_options queue: :default

    REVIEW_ACTIONS = ['opened', 'synchronize'].freeze

    def perform(delivery_id)
      delivery = GithubWebhookDelivery.find(delivery_id)
      delivery.processing!

<<<<<<< HEAD
      pull_request = Github::SyncPullRequestService.call(delivery)
      Reviews::GenerateService.call(pull_request) if review_required?(delivery, pull_request)
=======
      pull_request = Github::SyncPullRequestService.call(delivery)
      enqueue_review(pull_request, delivery) if review_required?(delivery, pull_request)
>>>>>>> 6056129 (feat: add comment review by AI on pull request)

      delivery.processed!
    rescue StandardError => e
      delivery&.failed!
      Rails.logger.error("GitHub webhook processing failed: #{e.class} - #{e.message}")
      raise
    end

    private

    def enqueue_review(pull_request, delivery)
      ai_model = pull_request.repository.ai_model || AiModel.find_by!(is_default: true, active: true)
      review = find_or_create_review(pull_request, ai_model, delivery)

      Reviews::GenerateJob.perform_later(review.id)
    end

    def find_or_create_review(pull_request, ai_model, delivery)
      review = pull_request.reviews.find_or_initialize_by(
        commit_sha: pull_request.head_commit_sha,
        ai_model: ai_model
      )

      if review.new_record?
        review.base_commit_sha = previous_commit_sha(pull_request) || delivery.payload.dig('pull_request', 'base', 'sha')
        review.status = 'processing'
        review.save!
      end

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
