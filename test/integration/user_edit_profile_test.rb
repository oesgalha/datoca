require 'test_helper'

class UserEditProfileTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "User can edit own profile" do

    labels = {
      name: User.human_attribute_name(:name)
    }
    user = users(:scientist1)
    name = "Novo nome"

    # Sign in
    sign_in(user)
    visit(root_path)

    # Go to profile
    assert(page.has_link?('Perfil'))
    click_link('Perfil')

    # Click the edit profile button
    assert(page.has_link?('Editar Perfil'))
    click_link('Editar Perfil')

    # Fill the form
    fill_in(labels[:name], with: name)
    click_on("Atualizar Usuário")

    # Ensure the user was updated
    page.assert_selector('div.notification.is-info', text: 'Perfil atualizado com sucesso.', visible: true)
    # Check for the updated name in the profile page
    page.assert_selector('p.title.is-bold.is-3', text: name, visible: true)
  end

  test "User can't edit other users profile" do
    alice = users(:scientist1)
    chuck = users(:scientist2)

    # Sign in
    sign_in(chuck)

    # Look for the edit button on other user profile
    visit(user_path(alice))
    refute(page.has_link?('Editar Perfil'))

    # Try direct acces to other user profile
    visit(edit_user_path(alice))
    page.assert_selector('div.notification.is-danger', text: 'Você não pode realizar essa ação', visible: true)
    assert_equal root_path, page.current_path
  end
end
