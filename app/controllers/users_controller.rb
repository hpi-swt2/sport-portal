class UsersController < Devise::RegistrationsController
  # https://github.com/CanCanCommunity/cancancan/wiki/authorizing-controller-actions
  load_and_authorize_resource only: [:edit, :update]
  load_resource only: [:link, :unlink]

  # GET /users
  # View: app/views/devise/registrations/index.html.erb
  def index
    @users = User.all
  end

  # GET /users/1
  # View: app/views/devise/registrations/show.html.erb
  def show
    @user = User.find(params[:id])
  end

  # GET /users/1/link
  def link
    authorize! :edit, @user
    redirect_to user_hpiopenid_omniauth_authorize_path
  end

  # GET /user/1/unlink
  def unlink
    authorize! :edit, @user
    if @user.has_omniauth?
      @user.uid = nil
      @user.provider = nil
      @user.save!
      redirect_to user_path(@user), notice: I18n.t('devise.registrations.unlink_success')
    else
      redirect_to user_path(@user), alert: I18n.t('devise.registrations.no_link')
    end
  end

  # GET /users/1/dashboard
  # View: app/views/devise/registrations/dashboard.html.erb
  def dashboard
    @user = User.find(params[:id])
  end
  # All other controller methods are handled by original `Devise::RegistrationsController`
  # Views are located in `app/views/devise`

  private

  # Overridden methods of `Devise::RegistrationsController` to permit additional model params
  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password)
  end
end
