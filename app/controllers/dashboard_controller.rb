class DashboardController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    @dashboard = Mock::Dashboard.call
  end
end
