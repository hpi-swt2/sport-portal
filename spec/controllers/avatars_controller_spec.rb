require 'rails_helper'

RSpec.describe AvatarsController, type: :controller do
  let(:invalid_attributes) {
    FactoryBot.build(:user).attributes
  }

  let(:avatar) {
    FactoryBot.create(:avatar)
  }

  describe "PUT #update" do
    context "when signed in" do
      before(:each) { sign_in avatar.user }

      context "with valid params" do
        let(:new_attributes) {
          { "image" => fixture_file_upload('valid_avatar2.png', 'image/png', :binary) }
        }

        it "updates the requested user's avatar" do
          expect{
            put :update, params: { id: avatar.user.to_param, avatar: new_attributes }  
            avatar.reload
          }.to change{avatar.image}
          
          #expect(avatar.user.avatar.image).to eq(new_attributes["image"])
        end

        it "redirects to the edit page" do
          put :update, params: { id: avatar.user.to_param, avatar: new_attributes }
          expect(response).to redirect_to(user_registration_path)
        end
      end

      context "with invalid params" do
        it "should raise an error" do
          expect{
            put :update, params: { id: avatar.user.to_param, avatar: invalid_attributes }
            }.to raise_error(ActiveModel::UnknownAttributeError)
          
        end
      end
    end

    context "when not signed in" do

    end
  end

  describe "DELETE #destroy" do
    context "when signed in" do
      before(:each) { sign_in avatar.user }

      it "destroys the requested user's avatar" do
        expect {
          delete :destroy, params: { id: avatar.user.to_param }
        }.to change{Avatar.exists?(avatar.id)}.to(false)
      end

      it "redirects to the edit page" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        delete :destroy, params: { id: avatar.user.to_param }
        expect(response).to redirect_to(user_registration_path)
      end
    end

    context "when not signed in" do
        it "doesn't destroy the requested user's avatar" do
        expect{
          delete :destroy, params: { id: avatar.user.to_param }
        }.to raise_error(CanCan::AccessDenied)
        

      end
    end
  end
end
