module Admin
  class ReviewsController < BaseController
    def show
      @user = User.find(params.expect(:user_id))
      @repository = @user.repositories.find(params.expect(:repository_id))
      @pull_request = @repository.pull_requests.find(params.expect(:pull_request_id))
      @review = @pull_request.reviews.includes(:ai_model).find(params.expect(:id))
      @changed_files = Github::FetchPullRequestDiffService.call(@pull_request, base_sha: @review.base_commit_sha, head_sha: @review.commit_sha)
    end
  end
end
