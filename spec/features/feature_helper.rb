require_relative '../spec_helper'
require 'capybara'
require 'capybara/dsl'
require 'capybara/rspec'
require 'paperclip/matchers'

module RubycomicsHelper

  def register_user(name, username, password)
    visit '/login'
    fill_in 'signup[name]', with: name
    fill_in 'signup[username]', with: username
    fill_in 'signup[password]', with: password
    fill_in 'signup[password_confirmation]', with: password
    click_on 'Create Account'
  end

  def log_in_user(username, password)
    visit '/login'
    fill_in 'login_info[username]', with: username
    fill_in 'login_info[password]', with: password
    click_on 'Log In'
  end

  def create_page
    newpage = Rubycomics::Page.new user_id: '1'
    newpage.page_img_file_name = File.expand_path('spec/assets/happy.jpg')
    newpage.save
  end
end

RSpec.configure do |c|
  c.include Capybara::DSL
  extend Paperclip::Shoulda::Matchers
  c.include RubycomicsHelper
end

Capybara.app = RubycomicsApp
