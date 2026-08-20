module Admin
  class PullRequestsController < BaseController
    before_action :set_user
    before_action :set_repository
    before_action :set_pull_request

    def show
      @reviews = @pull_request.reviews.includes(:ai_model).order(created_at: :desc)
    end
  end
end
