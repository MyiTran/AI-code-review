class ReviewsController < ApplicationController
  def index
    @reviews = Review.by_user(current_user)
      .includes(:ai_model, pull_request: :repository)
      .search_by_query(params[:query])
      .by_repository(params[:repository])
      .by_status(params[:status])
      .by_ai_model(params[:model])
      .order(created_at: :desc)

    @repositories = current_user.repositories.order(:name).pluck(:name, :id)
    @models = AiModel.where(active: true).order(:name).pluck(:name, :id)
  end

  def show
    @review = Review.by_user(current_user)
      .includes(:ai_model, pull_request: :repository)
      .find(params.expect(:id))

    @changed_files = Github::FetchPullRequestDiffService.call(
      @review.pull_request,
      base_sha: @review.base_commit_sha,
      head_sha: @review.commit_sha
    )
  end
end
