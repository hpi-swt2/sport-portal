class AvatarsController < ApplicationController
  load_and_authorize_resource :user
  load_and_authorize_resource :avatar, :through => :user

  def create
    @avatar = Avatar.new(avatar_params)
    @avatar.user = @user
    @avatar.save!
    redirect_to registration_path(@user)
  end

  def update
    @user.avatar.update(avatar_params)
    redirect_to registration_path(@user)
  end

  def destroy
    @user.avatar.destroy!
    redirect_to registration_path(@user)
  end

  private
    def avatar_params
      params.require(:avatar).permit!
    end
end