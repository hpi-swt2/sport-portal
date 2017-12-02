class AvatarsController < ApplicationController
  before_action :set_user
  before_action :set_avatar
  authorize_resource

  def create
    @avatar = Avatar.new(avatar_params)
    @avatar.user = @user
    @avatar.save!
    redirect_to registration_path(@user)
  end

  def update
    if @user.avatar.update(avatar_params)
      redirect_to edit_registration_path(@user)
    else
      render 'devise/registrations/edit'
    end
  end

  def destroy
    
    @avatar.update(image: nil)
    @avatar.destroy
    redirect_to user_registration_path
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def set_avatar
    @avatar = @user.avatar
  end

  def avatar_params
    params.require(:avatar).permit!
  end
end