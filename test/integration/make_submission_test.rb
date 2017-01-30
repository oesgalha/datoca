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

  test 'An user can not submit a subset of the solution' do
    chuck = create(:user)
    competition = create_competition_with_data

    # Sign in
    sign_in chuck
    visit competition_path(competition)

    click_on('Submeter')

    # Fill the form
    attach_file('Arquivo csv', random_csv(5))
    click_on('Criar Submissão')

    # Ensure the user is redirected to form page
    page.assert_selector('h1.title', text: 'Submeter resultado', visible: true)
    page.assert_selector('span.help.is-danger', text: 'não contém o mesmo número de linhas da solução esperada', visible: true)
    page.assert_selector('span.help.is-danger', text: 'a sua solução também deve conter os seguintes ids: 5,6,7,8,9', visible: true)
    assert_equal competition_submissions_path(competition), page.current_path

    # Try again with wrong headers
    attach_file('Arquivo csv', random_csv(11, ['idx', 'val']))
    click_on('Criar Submissão')

    # Ensure the user is redirected to form page
    page.assert_selector('h1.title', text: 'Submeter resultado', visible: true)
    page.assert_selector('span.help.is-danger', text: 'deve ter apenas as seguintes colunas: "id" e "value"', visible: true)
    assert_equal competition_submissions_path(competition), page.current_path
  end
end
