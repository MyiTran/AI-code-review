module Ai
  module Providers
    class GeminiService < ApplicationService
      BASE_URL = 'https://generativelanguage.googleapis.com'.freeze

      def initialize(model:, prompt:)
        @model = model
        @prompt = prompt
      end

      def call
        response = connection.post("/v1beta/models/#{model}:generateContent") do |request|
          request.params['key'] = ENV.fetch('GEMINI_API_KEY')
          request.headers['Content-Type'] = 'application/json'
          request.body = request_body.to_json
        end

        raise "Gemini request failed with status #{response.status}" unless response.success?

        parse_response(response.body)
      end

      private

      attr_reader :model, :prompt

      def connection = Faraday.new(url: BASE_URL)

      def request_body
        { contents: [{ parts: [{ text: prompt }] }] }
      end

      def parse_response(body)
        response = JSON.parse(body)

        {
          content: response.dig('candidates', 0, 'content', 'parts', 0, 'text'),
          tokens_used: response.dig('usageMetadata', 'totalTokenCount')
        }
      end
    end
  end
end
