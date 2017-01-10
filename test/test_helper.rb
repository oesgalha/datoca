ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/pride'
require 'capybara/rails'
require 'laranja'
SafeYAML::OPTIONS[:deserialize_symbols] = true
require 'codeclimate-test-reporter'

Laranja.load('pt-BR')
CodeClimate::TestReporter.start

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  # Include FactoryGirl helpers
  include FactoryGirl::Syntax::Methods

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def random_csv
    File.join(Rails.root, 'tmp', "#{rand(10)}.csv").tap do |fullpath|
      CSV.open(fullpath, 'wb') do |csv|
        csv << ['id', 'value']
        1.upto(10).each { |i| csv << [i.to_s, rand(1_000).to_s] }
      end
    end
  end
end
