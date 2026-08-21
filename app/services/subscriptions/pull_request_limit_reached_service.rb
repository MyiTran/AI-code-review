module Subscriptions
  class PullRequestLimitReachedService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      count = PullRequest.monthly_count(user)
      limit = Subscriptions::GetPlanLimitsService.call(user).fetch(:pull_requests)

      count >= limit
    end

    private

    attr_reader :user
  end
end
