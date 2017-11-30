class UsersController < Devise::RegistrationsController
  # https://github.com/CanCanCommunity/cancancan/wiki/authorizing-controller-actions
  load_and_authorize_resource only: [:update]
  load_resource only: [:link, :unlink]

  attr_reader :user

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
    authorize! :edit, user
    redirect_to user_hpiopenid_omniauth_authorize_path
  end

  # GET /user/1/unlink
  def unlink
    authorize! :edit, user
    if user.has_omniauth?
      unlink_omniauth
    else
      redirect_to user_path(user), alert: I18n.t('devise.registrations.no_link')
    end
  end

  # GET /admin/user/1/edit
  def edit
    @user = User.find(params[:id])
    authorize! :edit, @user
  end

  # GET /users/1/dashboard
  # View: app/views/devise/registrations/dashboard.html.erb
  def dashboard
    @user = User.find(params[:id])
  end

  # All other controller methods are handled by original `Devise::RegistrationsController`
  # Views are located in `app/views/devise`

  # PUT /admin/user/1/
  def update
    @user = User.find(params[:id])

    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end

    if @user.update(admin_account_update_params)
      redirect_to @user, notice: t('devise.update.success')
    else
      render :edit
    end
  end

  # POST /admin/user/1/
  def destroy
    @user.destroy
    redirect_to users_url, notice: I18n.t('helpers.flash.destroyed', resource_name: User.model_name.human).capitalize
  end

  private

  # Overridden methods of `Devise::RegistrationsController` to permit additional model params
  def sign_up_params
    generate_random_password if get_omniauth_data
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, event_ids: [])
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, event_ids: [])
  end

  def admin_account_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, event_ids: [])
  end

  def generate_random_password
    token = Devise.friendly_token 32
    user_params = params[:user]
    user_params[:password] = token
    user_params[:password_confirmation] = token
  end

  def get_omniauth_data
    if (data = session['omniauth.data'])
      data if data['expires'].to_time > Time.current
    end
  end

  def unlink_omniauth
    user.reset_omniauth
    user.save!
    redirect_to user_path(user), notice: I18n.t('devise.registrations.unlink_success')
  end
end
