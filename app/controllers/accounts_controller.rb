class AccountsController < ApplicationController
  def show
    @user = current_user
    @limits = Subscriptions::GetPlanLimitsService.call(@user)
  end

  def update
    current_user.update!(plan: params[:plan])
    redirect_to account_path, notice: 'Plan updated successfully'
  end
end
