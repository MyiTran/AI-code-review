module Subscriptions
  class PullRequestLimitReachedService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      count = Subscriptions::MonthlyPullRequestsCountService.call(user).to_i
      limit = Subscriptions::GetPlanLimitsService.call(user).fetch(:pull_requests).to_i

      count >= limit
    end

    private

    attr_reader :user
  end
end
