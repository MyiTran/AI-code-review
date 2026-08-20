module Subscriptions
  class ReviewLimitReachedService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      count = Subscriptions::MonthlyReviewsCountService.call(user).to_i
      limit = Subscriptions::GetPlanLimitsService.call(user).fetch(:reviews).to_i

      count >= limit
    end

    private

    attr_reader :user
  end
end
