module Subscriptions
  class GetAvailableAiModelsService < ApplicationService
    def initialize(user)
      @user = user
    end

    def call
      return AiModel.where(active: true) if user.pro?

      AiModel.where(active: true, is_premium: false)
    end

    private

    attr_reader :user
  end
end
