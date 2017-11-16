class AvatarsController < ApplicationController
  def update
    @user = User.find(params[:id])
    @user.update_attributes(avatar_update_params)
    redirect_to :back
  end

  def destroy
   @user = User.find(params[:id])
   @user.avatar = nil
   @user.save!
   redirect_to :back
  end

  private 
    def avatar_update_params
      params.require(:user).permit(:avatar)
    end
end
