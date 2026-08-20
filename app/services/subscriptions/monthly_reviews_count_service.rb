module Subscriptions
  class MonthlyReviewsCountService < ApplicationService
    EXPIRES_IN = 5.minutes

    def initialize(user)
      @user = user
    end

    def call
      Rails.cache.fetch(cache_key, expires_in: EXPIRES_IN) do
        Review.by_user(user).where(created_at: Time.current.all_month).count
      end
    end

    private

    attr_reader :user

    def cache_key
      "users/#{user.id}/monthly_reviews_count/#{Time.current.strftime('%Y-%m')}"
    end
  end
end
