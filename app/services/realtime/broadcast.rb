module Realtime
  class Broadcast
    def self.pull_request(pull_request)
      repository = pull_request.repository
      user = repository.github_installation.user

      Turbo::StreamsChannel.broadcast_refresh_to(user, :dashboard)
      Turbo::StreamsChannel.broadcast_refresh_to(pull_request.repository)
      Turbo::StreamsChannel.broadcast_refresh_to(pull_request)
    end

    def self.review(review)
      pull_request = review.pull_request
      repository = pull_request.repository
      user = repository.github_installation.user

      Turbo::StreamsChannel.broadcast_refresh_to(user, :dashboard)
      Turbo::StreamsChannel.broadcast_refresh_to(user, :reviews)
      Turbo::StreamsChannel.broadcast_refresh_to(repository)
      Turbo::StreamsChannel.broadcast_refresh_to(pull_request)
      Turbo::StreamsChannel.broadcast_refresh_to(review)
    end
  end
end
