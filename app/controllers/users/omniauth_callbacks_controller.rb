class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :hpiopenid

  # Omniauth callback for the provider 'hpiopenid'
  def hpiopenid
    if user_signed_in?
      @user = current_user
      if @user.provider.nil? and @user.uid.nil?
        auth = request.env['omniauth.auth']
        @user.uid = auth.uid
        @user.provider = auth.provider
        @user.save!
        set_flash_message(:notice, :link_success, provider: 'OpenID') if is_navigational_format?
      else
        set_flash_message(:error, :link_failure, provider: 'OpenID') if is_navigational_format?
      end
      redirect_to user_path(@user)
    else
      @user = User.from_omniauth(request.env['omniauth.auth'])
      if @user
        sign_in_and_redirect @user, event: :authentication #will throw if user is not activated
        set_flash_message(:notice, :success, provider: :openid) if is_navigational_format?
      else
        redirect_to root_path
      end
    end
  end
end
