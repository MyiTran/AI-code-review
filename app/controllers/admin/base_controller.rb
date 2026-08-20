module Admin
  class BaseController < ApplicationController
    layout 'admin'

    before_action :require_admin!

    private

    def require_admin!
      return if current_user&.admin? || current_user&.super_admin?

      redirect_to root_path, alert: 'You are not authorized to access admin.'
    end

    def set_user
      @user = User.find(params.expect(:user_id))
    end

    def set_repository
      repository_id = params[:repository_id] || params[:id]
      @repository = @user.repositories.find(repository_id)
    end

    def set_pull_request
      pull_request_id = params[:pull_request_id] || params[:id]
      @pull_request = @repository.pull_requests.find(pull_request_id)
    end
  end
end
