module Subscriptions
  class PullRequestLimitReachedService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      count >= Subscriptions::GetPlanLimitsService.call(user)[:pull_requests]
    end

    private

    attr_reader :user

    def count
      PullRequest.by_user(user).by_month.count
    end
  end
end
