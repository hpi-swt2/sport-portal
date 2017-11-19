class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :hpiopenid

  # Omniauth callback for the provider 'hpiopenid'
  def hpiopenid
    auth = request.env['omniauth.auth']
    if user_signed_in?
      attempt_link_with auth
    else
      attempt_sign_in_with auth
    end
  end

  protected

  def attempt_sign_in_with(auth)
    user = User.from_omniauth(auth)
    if user
      sign_in_user user
    else
      redirect_to root_path
      set_flash_message(:error, :failure, provider: 'OpenID') if is_navigational_format?
    end
  end

  def sign_in_user(user)
    sign_in_and_redirect user, event: :authentication #will throw if user is not activated
    set_flash_message(:notice, :success, provider: 'OpenID') if is_navigational_format?
  end

  def attempt_link_with(auth)
    user = current_user
    if user.has_omniauth?
      set_flash_message(:error, :link_failure, provider: 'OpenID') if is_navigational_format?
    else
      link_with user, auth
    end
    redirect_to user_path(user)
  end

  def link_with(user, auth)
    user.omniauth = auth
    user.save!
    set_flash_message(:notice, :link_success, provider: 'OpenID') if is_navigational_format?
  end
end
