module Admin
  class PullRequestsController < BaseController
    def show
      @user = User.find(params.expect(:user_id))
      @repository = @user.repositories.find(params.expect(:repository_id))
      @pull_request = @repository.pull_requests.find(params.expect(:id))
      @reviews = @pull_request.reviews.includes(:ai_model).order(created_at: :desc)
    end
  end
end
