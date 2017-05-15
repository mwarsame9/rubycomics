require_relative '../spec_helper'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require "paperclip/matchers"

RSpec.configure do |c|
  c.include Capybara::DSL
  extend Paperclip::Shoulda::Matchers
end

Capybara.app = RubycomicsApp
