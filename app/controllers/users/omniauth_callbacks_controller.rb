class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :hpiopenid

  # Omniauth callback for the provider 'hpiopenid'
  def hpiopenid
    if user_signed_in?
      @user = current_user
      #TODO: link account
    else
      @user = User.from_omniauth(request.env['omniauth.auth'])
      if @user
        sign_in_and_redirect @user, event: :authentication #will throw if user is not activated
        set_flash_message(:notice, :success_link, provider: 'OpenID') if is_navigational_format?
      else
        redirect_to root_path
      end
    end
  end

  # Omniauth callback for authentication failure
  def failure
    set_flash_message :failure, :error
    redirect_to root_path, error: 'NO LOGIN'
  end
end
