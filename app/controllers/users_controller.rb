class UsersController < Devise::RegistrationsController
  # https://github.com/CanCanCommunity/cancancan/wiki/authorizing-controller-actions
  load_and_authorize_resource :only => [:edit, :update, :edit_profile, :update_profile]

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

  # GET /users/1/dashboard
  # View: app/views/devise/registrations/dashboard.html.erb
  def dashboard
    @user = User.find(params[:id])
  end
  
  def edit_profile
  end

  def update_profile
    if @user.update(profile_update_params)
      redirect_to @user, notice: I18n.t('helpers.flash.updated', resource_name: User.model_name.human).capitalize
    else
      render :edit_profile
    end
  #This should only be possible if someone modifies the parameters with circumventing the input forms
  rescue NoMethodError
    render edit_profile
  rescue ArgumentError
    render edit_profile
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

  def profile_update_params
    safe_params = params.require(:user).permit(:birthday, :telephone_number, :telegram_username, :favourite_sports)
    safe_params[:birthday] = safe_params[:birthday].to_date
    safe_params
  end
end
