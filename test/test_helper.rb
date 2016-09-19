ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/pride'
require 'laranja'
Laranja.load('pt-BR')

class ActiveSupport::TestCase
  fixtures :all

  def random_record(record_class)
    record_class.offset(rand(record_class.count)).first
  end
end
