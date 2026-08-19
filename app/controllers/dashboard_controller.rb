class DashboardController < ApplicationController
  def index
    @dashboard = DashboardPresenter.new(user: current_user)
  end
end
