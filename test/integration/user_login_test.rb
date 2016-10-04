require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  test "User login" do

    labels = {
      email: User.human_attribute_name(:email),
      password: User.human_attribute_name(:password)
    }

    # Go home
    visit(root_path)
    assert(page.has_link?('Entrar'))

    # Click the sign in button
    click_link('Entrar')

    # Fill the form
    fill_in(labels[:email], with: users(:scientist1).email)
    fill_in(labels[:password], with: 'password')
    click_on("Entrar")

    # Ensure the user is logged in competitions path
    page.assert_selector('h1', text: 'Competições', visible: true)
  end
end
