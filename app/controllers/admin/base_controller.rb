module Admin
  class BaseController < ApplicationController
    layout 'admin'

    before_action :require_admin!

    private

    def require_admin!
      return if current_user&.admin? || current_user&.super_admin?

      redirect_to root_path, alert: 'You are not authorized to access admin'
    end
  end
end
