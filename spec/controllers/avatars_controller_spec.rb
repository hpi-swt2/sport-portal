require 'rails_helper'

RSpec.describe AvatarsController, type: :controller do
  let(:valid_attributes) {
    FactoryBot.build(:user).attributes
  }

  let(:invalid_attributes) {
    FactoryBot.build(:user).attributes
  }

  let(:user) {
    FactoryBot.create(:user)
  }

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { "avatar" => "" }
      }

      it "updates the requested user's avatar" do
        put :update, params: { id: user.to_param, user: new_attributes }
        user.reload
        expect(user.avatar).to eq(new_attributes["avatar"])
      end

      it "redirects to the edit page" do
        put :update, params: { id: user.to_param, user: valid_attributes }
        expect(response).to redirect_to(registration_path(user))
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        put :update, params: { id: user.to_param, user: invalid_attributes }
        expect(response).to be_success
      end
    end

    context "with other user's authentication" do

    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user's avatar" do
      expect {
        delete :destroy, params: { id: match.to_param }
      }.to change(User, :avatar).to(nil)
    end

    it "redirects to the edit page" do
      delete :destroy, params: { id: user.to_param }
      expect(response).to redirect_to(registration_path(user))
    end
  end
end

# TODO: test image path if nil and if not
# TODO: Show profile picture