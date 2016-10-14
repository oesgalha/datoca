ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/pride'
require 'capybara/rails'
require 'laranja'
require 'codeclimate-test-reporter'

Laranja.load('pt-BR')
CodeClimate::TestReporter.start

class ActiveSupport::TestCase
  fixtures :all

  def random_record(record_class)
    record_class.offset(rand(record_class.count)).first
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
