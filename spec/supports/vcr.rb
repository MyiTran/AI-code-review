require 'vcr'
require 'webmock/rspec'

VCR.configure do |config|
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = false
  config.ignore_localhost = true
  config.ignore_host 'chromedriver.storage.googleapis.com'
  config.cassette_library_dir = File.expand_path('../cassettes', __dir__)
  config.configure_rspec_metadata!
  config.default_cassette_options = {
    record: ENV['CI'] ? :none : :once,
    record_on_error: false,
    match_requests_on: %i[method uri body]
  }

  %w[Authorization X-Api-Key].each do |sensitive_header|
    config.filter_sensitive_data("[#{sensitive_header.upcase}]") do |interaction|
      interaction.request.headers[sensitive_header]&.first
    end
  end

  config.filter_sensitive_data('[GITHUB_APP_ID]') { ENV['GITHUB_APP_ID'] }
  config.filter_sensitive_data('[GITHUB_APP_PRIVATE_KEY]') { ENV['GITHUB_APP_PRIVATE_KEY'] }
  config.filter_sensitive_data('[GITHUB_WEBHOOK_SECRET]') { ENV['GITHUB_WEBHOOK_SECRET'] }
  config.filter_sensitive_data('[GEMINI_API_KEY]') { ENV['GEMINI_API_KEY'] }
  config.filter_sensitive_data('[TEST_GITHUB_INSTALLATION_ID]') { ENV['TEST_GITHUB_INSTALLATION_ID'] }
end
