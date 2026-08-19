module Realtime
  class BroadcastPullRequestService < ApplicationService
    def initialize(pull_request)
      @pull_request = pull_request
    end

    def call
      Turbo::StreamsChannel.broadcast_refresh_to(user, :dashboard)
      Turbo::StreamsChannel.broadcast_refresh_to(repository)
      Turbo::StreamsChannel.broadcast_refresh_to(pull_request)
    end

    private

    attr_reader :pull_request

    def repository
      @repository ||= pull_request.repository
    end

    def user
      @user ||= repository.github_installation.user
    end
  end
end
