require 'bundler/setup'
require_relative '../boot.rb'
require 'shoulda-matchers'
require 'shoulda-callback-matchers'
require 'capybara'
require 'timecop'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

Shoulda::Matchers.configure do |c|
  c.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
    with.library :active_model
  end
end
