module Admin
  class RepositoriesController < BaseController
    before_action :set_user
    before_action :set_repository

    def show
      @pull_requests = @repository.pull_requests.includes(:reviews).order(updated_at: :desc)
      @reviews = Review.joins(:pull_request).where(pull_requests: { repository_id: @repository.id }).includes(:ai_model, :pull_request).order(created_at: :desc)
    end
  end
end
