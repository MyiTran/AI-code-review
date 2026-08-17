class AccountsController < ApplicationController
  def show
    @user = current_user
    @limits = Subscriptions::GetPlanLimitsService.call(@user)
  end

  def update
    user = User.find(params.expect(:user_id))
    authorize user, :update?, policy_class: SubscriptionPolicy

    user.update!(plan: params.expect(:plan))
    redirect_to account_path, notice: 'Plan updated successfully'
  rescue Pundit::NotAuthorizedError
    redirect_to account_path, alert: 'Your session has changed. Please try again'
  end
end
