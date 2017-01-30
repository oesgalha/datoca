require 'test_helper'

class MakeSubmissionTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    Capybara.current_driver = :poltergeist
  end

  test 'An user can submit' do
    alice = create(:user)
    competition = create_competition_with_data

    # Sign in
    sign_in alice
    visit root_path

    # Look for the competition and enter it
    click_on(competition.name)
    click_on('Submeter')

    # Fill the form
    assert_difference [->{ Submission.count }, ->{ competition.submissions.count }] do
      attach_file('Arquivo csv', random_csv)
      click_on('Criar Submissão')
    end

    # Ensure the user is redirected to the submission summary page
    page.assert_selector('h1.title', text: 'Resumo de submissões', visible: true)
    page.assert_selector('h2.subtitle', text: competition.name, visible: true)
    assert_equal summary_competition_submissions_path(competition), page.current_path
  end
end
