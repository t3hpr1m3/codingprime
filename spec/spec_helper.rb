ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start 'rails' do
  add_filter "/vendor/"
end
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}

Warden.test_mode!

RSpec.configure do |config|
  config.use_transactional_fixtures = true
  config.include CustomControllerMatchers
  config.include Warden::Test::Helpers
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.lint
  end

  config.after do
    Warden.test_reset!
  end
end

FakeWeb.allow_net_connect = false

#def login_user(options = {})
#  @logged_in_user = Factory(:user, options)
#  login_as @logged_in_user
#  @logged_in_user
#end
#
#def login_admin( options = {} )
#  options[:is_admin] = true
#  @logged_in_user = Factory.build( :user, options )
#  @controller.stubs( :current_user ).returns( @logged_in_user )
#  @logged_in_user
#end
#
#def logout_user
#  @logged_in_user = nil
#  @controller.stubs( :current_user ).returns( @logged_in_user )
#  @logged_in_user
#end
