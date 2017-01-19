require 'test_helper'

class DownloadCompetitionDataTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    Capybara.current_driver = :poltergeist
  end

  test "An user can download competition data after rules acceptance" do
    alice = create(:user)
    competition = create_competition_with_data
    filename = competition.instructions.data.attachments.first.file_filename
    rules_text = 'By all means break the rules, and break them beautifully, deliberately and well. That is one of the ends for which they exist.'
    rules = competition.instructions.rules
    rules.markdown = rules_text
    rules.save

    # Sign in
    sign_in alice
    visit root_path

    # Look for the competition and enter it
    click_on(competition.name)

    # Look for the data
    click_on('Dados')

    # Click on the file url
    click_on(filename)

    # Ensure that a modal with the competition rules appear on the screen
    page.assert_selector('div.modal.is-active')
    page.assert_text(rules_text)

    # Accept the terms and download the file
    click_on('Confirmo que li e concordo com as regras')

    # Check if it downloaded the csv
    assert_equal "attachment; filename=\"#{filename}\"", page.response_headers['Content-Disposition']
    assert_includes Refile.types[:csv].content_type, page.response_headers['Content-Type']
  end

  test "An user that already accepted the rules can download the data again" do
    alice = create(:user)
    competition = create_competition_with_data
    competition.acceptances.create!(user: alice)
    filename = competition.instructions.data.attachments.first.file_filename

    # Sign in
    sign_in alice
    visit competition_path(competition)

    # Look for the data
    click_on('Dados')

    # Click on the file url
    click_on(filename)

    # Check if it downloaded the csv
    assert_equal "attachment; filename=\"#{filename}\"", page.response_headers['Content-Disposition']
    assert_includes Refile.types[:csv].content_type, page.response_headers['Content-Type']
  end
end
