require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  test "User login" do

    labels = {
      email: User.human_attribute_name(:email),
      password: User.human_attribute_name(:password)
    }

    # Go home
    visit(root_path)

    # Look for a login button and click it
    assert(page.has_link?('Entrar'))
    click_link('Entrar')

    # Fill the form
    fill_in(labels[:email], with: create(:user).email)
    fill_in(labels[:password], with: 'password')
    click_on("Entrar")

    # Ensure the user is logged in competitions path
    page.assert_selector('h1', text: 'Competições', visible: true)
  end
end
