module Realtime
  class BroadcastReviewService < ApplicationService
    def initialize(review)
      @review = review
    end

    def call
      Turbo::StreamsChannel.broadcast_refresh_to(user, :dashboard)
      Turbo::StreamsChannel.broadcast_refresh_to(user, :reviews)
      Turbo::StreamsChannel.broadcast_refresh_to(repository)
      Turbo::StreamsChannel.broadcast_refresh_to(pull_request)
      Turbo::StreamsChannel.broadcast_refresh_to(review)
    end

    private

    attr_reader :review

    def pull_request
      @pull_request ||= review.pull_request
    end

    def repository
      @repository ||= pull_request.repository
    end

    def user
      @user ||= repository.github_installation.user
    end
  end
end
