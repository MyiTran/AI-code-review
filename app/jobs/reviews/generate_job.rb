module Reviews
  class GenerateJob < ApplicationJob
    queue_as :default
    sidekiq_options retry: 3

    def perform(review_id)
      review = Review.find(review_id)
      review.update!(status: 'processing', error_message: nil)
      Realtime::Broadcast.review(review)

      Reviews::Generate.call(review)
      Github::CreatePullRequestComment.call(review)

      Realtime::Broadcast.review(review.reload)
    end

    sidekiq_retries_exhausted do |job, error|
      review_id = job.dig('args', 0, 'arguments', 0)
      review = Review.find_by(id: review_id)
      next unless review

      review.update!(status: 'failed', error_message: error.message)
      Realtime::Broadcast.review(review)
    end
  end
end
