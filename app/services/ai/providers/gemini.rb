module Ai
  module Providers
    class Gemini
      BASE_URL = 'https://generativelanguage.googleapis.com'.freeze

      def self.call(model:, prompt:)
        response = connection.post("/v1beta/models/#{model}:generateContent") do |request|
          request.params['key'] = ENV.fetch('GEMINI_API_KEY')
          request.headers['Content-Type'] = 'application/json'
          request.body = request_body(prompt).to_json
        end

        raise "Gemini request failed with status #{response.status}" unless response.success?

        parse_response(response.body)
      end

      def self.connection
        Faraday.new(url: BASE_URL)
      end

      def self.request_body(prompt)
        {
          contents: [
            {
              parts: [
                { text: prompt }
              ]
            }
          ]
        }
      end

      def self.parse_response(body)
        response = JSON.parse(body)

        {
          content: response.dig('candidates', 0, 'content', 'parts', 0, 'text'),
          tokens_used: response.dig('usageMetadata', 'totalTokenCount')
        }
      end

      private_class_method :connection
      private_class_method :request_body
      private_class_method :parse_response
    end
  end
end
