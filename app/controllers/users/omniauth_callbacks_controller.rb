class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    oauth_user_action('Facebook')
  end

  def linkedin
    oauth_user_action('Linkedin')
  end

  def google_oauth2
    oauth_user_action('Google')
  end

  def failure
    redirect_to root_path
  end

  private

  def oauth_user_action(provider)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider)
    else
      redirect_to new_user_registration_url
    end
  end
end
