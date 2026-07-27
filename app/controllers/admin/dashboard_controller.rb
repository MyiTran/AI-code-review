module Admin
  class DashboardController < ApplicationController
    def index
      @admin = Mock::AdminDashboard.data
    end
  end
end
