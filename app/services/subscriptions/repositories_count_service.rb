module Subscriptions
  class RepositoriesCountService < ApplicationService
    EXPIRES_IN = 5.minutes

    def initialize(user)
      @user = user
    end

    def call
      Rails.cache.fetch(cache_key, expires_in: EXPIRES_IN) { user.repositories.count }
    end

    private

    attr_reader :user

    def cache_key
      "users/#{user.id}/repositories_count"
    end
  end
end
