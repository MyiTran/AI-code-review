module Subscriptions
  class RepositoryLimitReachedService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      count = Repository.cached_count(user)
      limit = Subscriptions::GetPlanLimitsService.call(user).fetch(:repositories)

      count >= limit
    end

    private

    attr_reader :user
  end
end
