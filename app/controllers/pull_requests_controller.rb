class PullRequestsController < ApplicationController
  def show
    @pull_request = current_user_pull_requests.find(params.expect(:id))
    @reviews = @pull_request.reviews.includes(:ai_model).order(created_at: :desc)
  end

  private

  def current_user_pull_requests
    PullRequest.by_user(current_user)
  end
end
