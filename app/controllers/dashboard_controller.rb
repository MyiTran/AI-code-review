class DashboardController < ApplicationController
  def index
    repositories = current_user.repositories
    reviews = Review.by_user(current_user)

    @repository_count = repositories.count
    @pull_request_count = PullRequest.where(repository: repositories).count
    @review_count = reviews.count
    @issues_found_count = reviews.sum(:issues_found_count)

    @repositories = repositories.includes(:ai_model).order(updated_at: :desc).limit(5)
    @recent_reviews = reviews.includes(:ai_model, pull_request: :repository).order(created_at: :desc).limit(5)
  end
end
