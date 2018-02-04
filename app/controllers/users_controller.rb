class UsersController < Devise::RegistrationsController
  # https://github.com/CanCanCommunity/cancancan/wiki/authorizing-controller-actions
  helper_method :error_detector
  load_and_authorize_resource :user, only: [:index, :show, :edit, :destroy, :confirm_destroy, :dashboard, :notifications]
  load_resource only: [:link, :unlink]

  attr_reader :user

  # GET /users
  # View: app/views/devise/registrations/index.html.erb
  def index
    @users = User.all
    authorize! :index, User
  end

  # GET /users/1
  # View: app/views/devise/registrations/show.html.erb
  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
    authorize! :edit, @user
  end

  def update
    @user = User.find(params[:id])
    authorize! :update, @user
    unless current_user.admin?
      super
    else
      if @user.update(admin_update_params)
        redirect_to @user, notice: I18n.t('helpers.flash.updated', resource_name: User.model_name.human).capitalize
      else
        render :edit
      end
    end
  end

  def confirm_destroy
    if @user.destroy_with_password(params[:password])
      set_flash_message! :notice, :destroyed
      redirect_to root_path
    else
      render :destroy
    end
  end

  def destroy
    render :destroy
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

  # GET /users/1/notifications
  def notifications
  end

  # PATCH /users/1/update_notifications
  def update_notifications
    @user = User.find(params[:id])
    authorize! :update, @user
    user_params = params[:user]
    @user.update(event_notifications_enabled: user_params[:event_notifications_enabled],
                team_notifications_enabled: user_params[:team_notifications_enabled])
    redirect_to notifications_user_path(@user)
  end

  # GET /users/1/dashboard
  # View: app/views/devise/registrations/dashboard.html.erb
  def dashboard
    @user = User.find(params[:id])
  end

  # All other controller methods are handled by original `Devise::RegistrationsController`
  # Views are located in `app/views/devise`

  protected
    # Implemented to redirect to user profile after successful update
    def user_root_path
      user_path current_user
    end

    # Override method of `Devise::RegistrationsController` to update without password
    def  update_resource(resource, params)
      if self.class.unimportant_changes?(resource, params) || resource.has_omniauth?
        resource.update_without_password(params)
      else
        super(resource, params)
      end
    end

  private

    def self.unimportant_changes?(resource, params)
      (params[:current_password].blank? &&
          params[:password].blank? &&
          params[:password_confirmation].blank? &&
          (params[:email].blank? || params[:email] == resource[:email]))
    end

    # Overridden methods of `Devise::RegistrationsController` to permit additional model params
    def sign_up_params
      generate_random_password if get_omniauth_data
      params.require(:user).permit(:first_name, :last_name, :email, :password, :image, :remove_image, :password_confirmation, :avatar, :remove_avatar, :birthday, :telephone_number, :telegram_username, :favourite_sports, :team_notifications_enabled, :event_notifications_enabled, event_ids: [])
    end

    def account_update_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :avatar, :remove_avatar, :birthday, :telephone_number, :telegram_username, :favourite_sports, :team_notifications_enabled, :event_notifications_enabled, event_ids: [])
    end

    def admin_update_params
      user_params = params[:user]
      if user_params[:password].blank?
        user_params.delete(:password)
        user_params.delete(:password_confirmation)
      end
      params.require(:user).permit(:first_name, :last_name, :birthday, :email, :password, :password_confirmation)
    end

    def generate_random_password
      token = Devise.friendly_token User::OMNIAUTH_PASSWORD_LENGTH
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

    def error_detector(attribute)
      if resource.errors.include?(attribute) then "input-field-error input-field" else "input-field" end
    end
end
