require 'simplecov'

SimpleCov.start do
  skip 'config/'
  skip 'spec/'

  group 'Models', 'app/models'
  group 'Controllers', 'app/controllers'
  group 'Jobs', 'app/jobs'
  group 'Mailers', 'app/mailers'
  group 'Serializers', 'app/serializers'
  group 'Services', 'app/services'
  group 'Policies', 'app/policies'
  group 'Queries', 'app/queries'
end

require 'spec_helper'

ENV['RAILS_ENV'] ||= 'test'

require_relative '../config/environment'

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
require 'faker'
require 'shoulda/matchers'

Rails.root.glob('spec/supports/**/*.rb').sort.each { |file| require file }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [
    Rails.root.join('spec/fixtures')
  ]

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.before(:each, type: :request) do
    allow_any_instance_of(ActionView::Base)
      .to receive(:vite_javascript_tag)
      .and_return('')

    allow_any_instance_of(ActionView::Base)
      .to receive(:vite_client_tag)
      .and_return('')
  end
end
