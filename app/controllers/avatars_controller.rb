class AvatarsController < ApplicationController
  load_and_authorize_resource :user

  def update
    @user.update_attributes(avatar_update_params)
    redirect_to registration_path(@user)
  end

  def destroy
    @user.avatar = nil
    @user.save!
    redirect_to registration_path(@user)
  end

  private
    def avatar_update_params
      params.require(:user).permit(:avatar)
    end
end
