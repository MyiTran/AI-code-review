class ReviewRetriesController < ApplicationController
  def create
    review = current_user_reviews.find(params.expect(:review_id))

    if review.status == 'failed'
      review.update!(status: 'processing', error_message: nil)
      Reviews::GenerateJob.perform_later(review.id)
    end

    redirect_back_or_to(review_path(review), notice: 'Review retry started.')
  end

  private

  def current_user_reviews
    Review.joins(pull_request: { repository: :github_installation }).where(github_installations: { user_id: current_user.id })
  end
end
