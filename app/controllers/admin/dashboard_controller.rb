module Admin
  class DashboardController < BaseController
    def index
      @admin = Mock::AdminDashboard.data
    end
  end
end