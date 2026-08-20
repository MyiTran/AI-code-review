module Subscriptions
  class RepositoryLimitReachedService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      count = Subscriptions::RepositoriesCountService.call(user).to_i
      limit = Subscriptions::GetPlanLimitsService.call(user).fetch(:repositories).to_i

      count >= limit
    end

    private

    attr_reader :user
  end
end
