module Subscriptions
  class RepositoryLimitReachedService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      user.repositories.where(connected: true).count >= Subscriptions::GetPlanLimitsService.call(user)[:repositories]
    end

    private

    attr_reader :user
  end
end
