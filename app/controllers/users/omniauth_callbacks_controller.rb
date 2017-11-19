class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :hpiopenid

  # Omniauth callback for the provider 'hpiopenid'
  def hpiopenid
    auth = request.env['omniauth.auth']
    if user_signed_in?
      link_with auth
    else
      sign_in_with auth
    end
  end

  protected
  def sign_in_with(auth)
    user = User.from_omniauth(request.env['omniauth.auth'])
    if user
      sign_in_and_redirect user, event: :authentication #will throw if user is not activated
      set_flash_message(:notice, :success, provider: :openid) if is_navigational_format?
    else
      redirect_to root_path
      set_flash_message(:error, :failure, provider: 'OpenID') if is_navigational_format?
    end
  end

  def link_with(auth)
    user = current_user
    if user.has_omniauth?
      set_flash_message(:error, :link_failure, provider: 'OpenID') if is_navigational_format?
    else
      user.uid = auth.uid
      user.provider = auth.provider
      user.save!
      set_flash_message(:notice, :link_success, provider: 'OpenID') if is_navigational_format?
    end
    redirect_to user_path(user)
  end
end
