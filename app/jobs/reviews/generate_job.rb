module Reviews
  class GenerateJob < ApplicationJob
    queue_as :default
    sidekiq_options retry: 3

    def perform(review_id)
      review = Review.find(review_id)
      review.update!(status: 'processing', error_message: nil)

      Reviews::Generate.call(review)
      Github::CreatePullRequestComment.call(review)
    end

    sidekiq_retries_exhausted do |job, error|
      review_id = job.dig('args', 0, 'arguments', 0)
      review = Review.find_by(id: review_id)

      review&.update!(status: 'failed', error_message: error.message)
    end
  end
end
