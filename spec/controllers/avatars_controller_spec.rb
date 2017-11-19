require 'rails_helper'

RSpec.describe AvatarsController, type: :controller do
  let(:invalid_attributes) {
    FactoryBot.build(:user).attributes
  }

  describe "PUT #update" do
      let(:user) {
        FactoryBot.create(:user, avatar: nil)
      }

    context "when signed in" do
      before(:each) { sign_in user }

      context "with valid params" do
        let(:new_attributes) {
          { "avatar" => File.new("#{Rails.root}/spec/support/fixtures/valid_avatar.png") }
        }

        it "updates the requested user's avatar" do
          put :update, params: { id: user.to_param, user: new_attributes }
          user.reload
          expect(response).to_not be_success
          expect(user.avatar).to eq(new_attributes["avatar"])
        end

        it "redirects to the edit page" do
          put :update, params: { id: user.to_param, user: new_attributes }
          expect(response).to redirect_to(registration_path(user))
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          put :update, params: { id: user.to_param, user: invalid_attributes }
          expect(response).to_not be_success
        end
      end
    end

    context "when not signed in" do

    end
  end

  describe "DELETE #destroy" do
    let(:user) {
      FactoryBot.create(:user)
    }

    context "when signed in" do
      before(:each) { sign_in user }

      it "destroys the requested user's avatar" do
        expect {
          delete :destroy, params: { id: user.to_param }
        }.to change(user, :avatar).to(nil)
      end

      it "redirects to the edit page" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        delete :destroy, params: { id: user.to_param }
        expect(response).to redirect_to(registration_path(user))
      end
    end

    context "when not signed in" do

    end
  end
end
