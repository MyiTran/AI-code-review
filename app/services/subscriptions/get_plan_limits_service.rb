module Subscriptions
  class GetPlanLimitsService < ApplicationService
    FREE = { repositories: 8, pull_requests: 22, reviews: 38 }.freeze
    PRO = { repositories: 50, pull_requests: 500, reviews: 1_000 }.freeze

    def initialize(user)
      @user = user
    end

    def call
      user.pro? ? PRO : FREE
    end

    private

    attr_reader :user
  end
end
