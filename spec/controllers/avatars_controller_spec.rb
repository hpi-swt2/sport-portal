require 'rails_helper'

RSpec.describe AvatarsController, type: :controller do
  let(:valid_attributes) {
    FactoryBot.build(:user).attributes
  }

  let(:invalid_attributes) {
    FactoryBot.build(:user).attributes
  }

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { "avatar" => "" }
      }

      it "updates the requested user's avatar" do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: new_attributes }
        user.reload
        expect(user.avatar).to eq(new_attributes["date"])
      end

      it "redirects to the edit page" do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: valid_attributes }
        expect(response).to redirect_to(user)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        user = User.create! valid_attributes
        put :update, params: { id: user.to_param, user: invalid_attributes }
        expect(response).to be_success
      end
    end

    context "with other user's authentication" do

    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user's avatar" do
      user = Match.create! valid_attributes
      expect {
        delete :destroy, params: { id: match.to_param }
      }.to change(User, :avatar).to(nil)
    end

    it "redirects to the edit page" do
      user = User.create! valid_attributes
      delete :destroy, params: { id: user.to_param }
      expect(response).to redirect_to(matches_url)
    end
  end
end

# TODO: test image path if nil and if not