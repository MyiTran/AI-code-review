module Admin
  class RepositoriesController < BaseController
    def show
      @user = User.find(params.expect(:user_id))
      @repository = @user.repositories.find(params.expect(:id))
      @pull_requests = @repository.pull_requests.includes(:reviews).order(updated_at: :desc)
      @reviews = Review.joins(:pull_request).where(pull_requests: { repository_id: @repository.id }).includes(:ai_model, :pull_request).order(created_at: :desc)
    end
  end
end
