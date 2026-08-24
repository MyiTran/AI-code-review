module Admin
  class RepositoriesController < BaseController
    before_action :set_user
    before_action :set_repository

    def show
      @pull_requests = @repository.pull_requests.includes(:reviews).order(updated_at: :desc)
      @reviews = @repository.reviews.order(created_at: :desc)
    end
  end
end
