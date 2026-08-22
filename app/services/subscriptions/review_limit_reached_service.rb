module Subscriptions
  class ReviewLimitReachedService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      count >= Subscriptions::GetPlanLimitsService.call(user)[:reviews]
    end

    private

    attr_reader :user

    def count
      Review.by_user(user).where(created_at: Time.current.all_month).count
    end
  end
end
