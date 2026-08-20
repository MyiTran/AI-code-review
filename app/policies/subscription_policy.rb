class SubscriptionPolicy < ApplicationPolicy
  def update?
    user == record
  end
end
