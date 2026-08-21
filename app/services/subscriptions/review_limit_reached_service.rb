module Subscriptions
  class ReviewLimitReachedService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      count = Review.monthly_count(user)
      limit = Subscriptions::GetPlanLimitsService.call(user).fetch(:reviews)

      count >= limit
    end

    private

    attr_reader :user
  end
end
