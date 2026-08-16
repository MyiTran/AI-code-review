class DashboardController < ApplicationController
  def index # rubocop:disable Metrics/AbcSize
    repositories = current_user.repositories
    reviews = Review.by_user(current_user)

    @repository_count = repositories.where(connected: true).count
    @repository_limit = Subscriptions::GetPlanLimitsService.call(current_user)[:repositories]
    @pull_request_count = PullRequest.where(repository: repositories).count
    @review_count = reviews.count
    @issues_found_count = reviews.sum(:issues_found_count)

    @plan_name = current_user.pro? ? 'Pro' : 'Free'
    @monthly_review_limit = Subscriptions::GetPlanLimitsService.call(current_user)[:reviews]
    @monthly_review_count = reviews.where(created_at: Time.current.all_month).count
    @monthly_usage_percent = [(@monthly_review_count.to_f / @monthly_review_limit * 100).round, 100].min
    @monthly_review_remaining = [@monthly_review_limit - @monthly_review_count, 0].max

    @repositories = repositories.includes(:ai_model).order(updated_at: :desc).limit(5)
    @recent_reviews = reviews.includes(:ai_model, pull_request: :repository).order(created_at: :desc).limit(5)
  end
end
