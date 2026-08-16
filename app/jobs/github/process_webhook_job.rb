module Github
  class ProcessWebhookJob < ApplicationJob
    queue_as :default
    sidekiq_options retry: 3

    def perform(delivery_id)
      delivery = GithubWebhookDelivery.find(delivery_id)
      delivery.processing!

      pull_request = Github::SyncPullRequest.call(delivery)
      Realtime::Broadcast.pull_request(pull_request) if pull_request.present?
      enqueue_review(pull_request) if review_required?(delivery, pull_request)

      delivery.processed!
    rescue StandardError => e
      delivery&.failed!
      Rails.logger.error("GitHub webhook processing failed: #{e.class} - #{e.message}")
      raise
    end

    private

    def enqueue_review(pull_request)
      user = pull_request.repository.github_installation.user
      limit = Subscriptions::GetPlanLimitsService.call(user)[:reviews]
      return if Review.by_user(user).where(created_at: Time.current.all_month).count >= limit

      ai_model = pull_request.repository.ai_model || AiModel.find_by!(is_default: true, active: true)
      review = find_or_create_review(pull_request, ai_model)

      Realtime::Broadcast.review(review)
      Reviews::GenerateJob.perform_later(review.id)
    end

    def find_or_create_review(pull_request, ai_model)
      review = pull_request.reviews.find_or_initialize_by(commit_sha: pull_request.head_commit_sha, ai_model: ai_model)
      return review if review.persisted?

      review.base_commit_sha = previous_commit_sha(pull_request)
      review.triggered_by = Github::FetchCommitAuthorService.call(pull_request, pull_request.head_commit_sha)
      review.status = 'processing'
      review.save!
      review
    end

    def previous_commit_sha(pull_request)
      pull_request.reviews.where(status: 'completed').order(created_at: :desc).pick(:commit_sha)
    end

    def review_required?(delivery, pull_request)
      pull_request.present? && %w[opened synchronize].include?(delivery.action) && pull_request.repository.auto_review_enabled?
    end
  end
end
