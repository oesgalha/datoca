require 'test_helper'

class CreateCompetitionTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "An user can create a team" do
    alice = create(:user)
    bob = create(:user)

    # Sign in
    sign_in alice
    visit root_path

    # Go to profile
    click_link 'Perfil'

    # Click create team button
    click_link 'Criar Equipe'

    # Fill form
    assert_difference ->{ Team.count } do
      fill_in('Nome', with: 'Dados viciados')
      select(bob.name, from: 'Usuários')
      click_on('Criar Equipe')
    end

    # Ensure the team contains alice and bob
    team_ids = Team.last.user_ids
    assert team_ids.include?(alice.id)
    assert team_ids.include?(bob.id)
  end

  test "Can't create a team without a name" do
    alice = create(:user)
    bob = create(:user)

    # Sign in
    sign_in alice
    visit root_path

    # Go to profile
    click_link 'Perfil'

    # Click create team button
    click_link 'Criar Equipe'

    # Try to create a team without filling the form
    click_on('Criar Equipe')

    # Ensure user return to the form
    page.assert_selector('h1.title', text: 'Novo Time')
    page.assert_selector('span.help.is-danger', text: 'não pode ficar em branco')
  end
end
