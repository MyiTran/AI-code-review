module Admin
  class ApplicationController < ::ApplicationController
    layout 'admin'

    before_action :authenticate_admin!

    private

    def authenticate_admin!
      return if current_user.admin?

      redirect_to dashboard_path, alert: 'You are not authorized to access this page.'
    end
  end
end
