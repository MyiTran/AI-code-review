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
      PullRequest.joins(repository: :github_installation).where(github_installations: { user_id: user.id }, created_at: Time.current.all_month).count
    end
  end
end
