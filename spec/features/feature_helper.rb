require_relative '../spec_helper'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'

RSpec.configure do |c|
  c.include Capybara::DSL
end

Capybara.app = RubycomicsApp
