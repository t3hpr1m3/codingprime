ENV["RAILS_ENV"] ||= 'test'
require 'simplecov'
SimpleCov.start 'rails'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
#require 'shoulda'
#require File.expand_path(File.join(File.dirname(__FILE__),'/factories'))

# Uncomment the next line to use webrat's matchers
#require 'webrat/integrations/rspec-rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :mocha
  config.use_transactional_fixtures = true
  config.include CustomControllerMatchers
end

def login_user( options = {} )
  @logged_in_user = Factory.build( :user, options )
  @controller.stubs( :current_user ).returns( @logged_in_user )
  @logged_in_user
end

def login_admin( options = {} )
  options[:is_admin] = true
  @logged_in_user = Factory.build( :user, options )
  @controller.stubs( :current_user ).returns( @logged_in_user )
  @logged_in_user
end

def logout_user
  @logged_in_user = nil
  @controller.stubs( :current_user ).returns( @logged_in_user )
  @logged_in_user
end
