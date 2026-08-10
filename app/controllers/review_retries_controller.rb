class ReviewRetriesController < ApplicationController
  def create
    review = Review.by_user(current_user).find(params.expect(:review_id))

    if review.status == 'failed'
      review.update!(status: 'processing', error_message: nil)
      Realtime::Broadcast.review(review)
      Reviews::GenerateJob.perform_later(review.id)
    end

    redirect_back_or_to(review_path(review), notice: 'Review retry started.')
  end
end
