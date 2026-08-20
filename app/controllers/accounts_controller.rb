class AccountsController < ApplicationController
  def show
    @limits = Subscriptions::GetPlanLimitsService.call(current_user)
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
