ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/pride'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'laranja'

Laranja.load('pt-BR')
Capybara.javascript_driver = :poltergeist
TransactionalCapybara.share_connection

module DatocaTestHelpers
  def random_csv(lines = 11, headers = ['id', 'value'])
    File.join(Rails.root, 'tmp', "#{rand(10)}.csv").tap do |fullpath|
      CSV.open(fullpath, 'wb') do |csv|
        csv << headers
        1.upto(lines - 1).each { |i| csv << [i.to_s, rand(1_000).to_s] }
      end
    end
  end

  def create_competition_with_data
    create(:competition).tap do |comp|
      comp.instructions.data.tap do |data|
        data.attachments_attributes = [
          { file: File.open(random_csv) }
        ]
        data.markdown = _attachment_md_url(data.attachments.first)
      end.save!
    end
  end

  private

  def _attachment_md_url(att)
    "[#{att.file_file_name}](#{att.permanent_url})"
  end
end

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
  include DatocaTestHelpers
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  # Include FactoryGirl helpers
  include FactoryGirl::Syntax::Methods

  include DatocaTestHelpers

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
