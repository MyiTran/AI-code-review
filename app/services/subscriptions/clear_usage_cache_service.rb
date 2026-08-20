module Subscriptions
  class ClearUsageCacheService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      Rails.cache.delete("users/#{user.id}/repositories_count")
      Rails.cache.delete("users/#{user.id}/monthly_pull_requests_count/#{current_month}")
      Rails.cache.delete("users/#{user.id}/monthly_reviews_count/#{current_month}")
    end

    private

    attr_reader :user

    def current_month
      Time.current.strftime('%Y-%m')
    end
  end
end
