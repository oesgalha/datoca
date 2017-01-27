require 'test_helper'

class MakeSubmissionTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    Capybara.current_driver = :poltergeist
  end

  test "An user can submit" do
    alice = create(:user)
    # TODO
  end
end
