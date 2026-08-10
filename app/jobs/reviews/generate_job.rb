module Reviews
  class GenerateJob
    include Sidekiq::Job

    sidekiq_options queue: :default, retry: 3

    def perform(review_id)
      review = Review.find(review_id)
      review.update!(status: 'processing', error_message: nil)

      Reviews::GenerateService.call(review)
      Github::CreatePullRequestCommentService.call(review)
    end

    sidekiq_retries_exhausted do |job, error|
      review = Review.find_by(id: job['args'].first)

      if review.present?
        review.update!(status: 'failed', error_message: error.message)
        Realtime::BroadcastReviewService.call(review)
      end
    end
  end
end
