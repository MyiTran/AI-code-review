module Admin
  class ReviewsController < BaseController
    before_action :set_user
    before_action :set_repository
    before_action :set_pull_request
    before_action :set_review

    def show
      @changed_files = Github::FetchPullRequestDiffService.call(@pull_request, base_sha: @review.base_commit_sha, head_sha: @review.commit_sha)
    end

    private

    def set_review
      @review = @pull_request.reviews.includes(:ai_model).find(params.expect(:id))
    end
  end
end
