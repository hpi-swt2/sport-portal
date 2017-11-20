# Controller that handles omniauth callbacks (e.g. OpenID)
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
        flash_if_navigational :error, :failure, provider: 'OpenID'
      end
    end

    def sign_in_user(user)
      sign_in_and_redirect user, event: :authentication #will throw if user is not activated
      flash_if_navigational :notice, :success, provider: 'OpenID'
    end

    def attempt_link_with(auth)
      user = current_user
      if user.has_omniauth?
        flash_if_navigational :error, :link_failure, provider: 'OpenID'
      else
        link_with user, auth
      end
      redirect_to user_path(user)
    end

    def link_with(user, auth)
      user.omniauth = auth
      user.save!
      flash_if_navigational :notice, :link_success, provider: 'OpenID'
    end

    def flash_if_navigational(key, kind, options = {})
      set_flash_message(key, kind, options) if is_navigational_format?
    end
end
