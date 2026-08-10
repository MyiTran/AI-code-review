class DashboardController < ApplicationController
  def index
    @dashboard = Mock::Dashboard.call
  end
end
