require 'test_helper'

class DownloadCompetitionDataTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    Capybara.current_driver = :poltergeist
  end

  test "An user can download competition data after rules acceptance" do
    alice = create(:user)
    competition = competition_with_data
    attachment = competition.instructions.data.attachments.first
    rules_text = ActionView::Base.full_sanitizer.sanitize(competition.instructions.rules.html)

    # Sign in
    sign_in alice
    visit root_path

    # Look for the competition and enter it
    click_on(competition.name)

    # Look for the data
    click_on("Dados")

    # Click on the file url
    click_on(attachment.file_filename)

    # Ensure a modal with the competition rules appear on the screen
    page.assert_selector('div.modal.is-active', visible: :all)
  end
end
