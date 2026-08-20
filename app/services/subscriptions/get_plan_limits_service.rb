module Subscriptions
  class GetPlanLimitsService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      user.pro? ? pro_limits : free_limits
    end

    private

    attr_reader :user

    def free_limits
      { repositories: ENV.fetch('FREE_REPOSITORIES_LIMIT').to_i, pull_requests: ENV.fetch('FREE_PULL_REQUESTS_LIMIT').to_i, reviews: ENV.fetch('FREE_REVIEWS_LIMIT').to_i }
    end

    def pro_limits
      { repositories: ENV.fetch('PRO_REPOSITORIES_LIMIT').to_i, pull_requests: ENV.fetch('PRO_PULL_REQUESTS_LIMIT').to_i, reviews: ENV.fetch('PRO_REVIEWS_LIMIT').to_i }
    end
  end
end
