require 'test_helper'

class UserRegisterTest < ActionDispatch::IntegrationTest
  test "User register" do

    labels = {
      name: User.human_attribute_name(:name),
      email: User.human_attribute_name(:email),
      password: User.human_attribute_name(:password)
    }

    name = Laranja::Nome.nome
    email = Laranja::Internet.email
    password = Laranja::Internet.password

    # Go home
    visit(root_path)
    assert(page.has_link?('Cadastrar'))

    # Click the sign up button
    click_link('Cadastrar')

    # Fill the form
    assert_difference([->{ User.count }]) do
      fill_in(labels[:name], with: name)
      fill_in(labels[:email], with: email)
      fill_in(labels[:password], with: password)
      click_on("Registrar")
    end

    # Ensure the user is logged in competitions path
    page.assert_selector('h1', text: 'Competições', visible: true)
  end
end
