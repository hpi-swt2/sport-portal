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
          { "avatar" => fixture_file_upload('valid_avatar.png', 'image/png', :binary) }
        }

        it "updates the requested user's avatar" do
          put :update, params: { id: avatar.user.to_param, avatar: new_attributes }
          avatar.reload
          expect(response).to_not be_success
          expect(user.avatar).to eq(new_attributes["avatar"])
        end

        it "redirects to the edit page" do
          put :update, params: { id: user.to_param, avatar: new_attributes }
          expect(response).to redirect_to(registration_path(avatar.user))
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          put :update, params: { id: avatar.user.to_param, avatar: invalid_attributes }
          expect(response).to_not be_success
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
        }.to change(avatar.user, :avatar).to(nil)
      end

      it "redirects to the edit page" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        delete :destroy, params: { id: avatar.user.to_param }
        expect(response).to redirect_to(registration_path(avatar.user))
      end
    end

    context "when not signed in" do

    end
  end
end
