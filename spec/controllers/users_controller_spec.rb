require 'rails_helper'

# There are no expectations of assigns and templates rendered in this spec.
# These features have been removed from Rails core in Rails 5, but can be
# added back in via the `rails-controller-testing` gem.

RSpec.describe UsersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    FactoryBot.attributes_for(:user)
  }

  before(:each) do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:admin)
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  after(:each) do
    @user.destroy
    @other_user.destroy
    @admin.destroy
  end

  describe "GET #index" do
    it "returns a success response" do
      # https://github.com/plataformatec/devise/wiki/How-To:-Test-controllers-with-Rails-3-and-4-%28and-RSpec%29#mappings
      user = User.create! valid_attributes
      get :index, params: {}
      expect(response).to be_success
    end

    it "should allow normal user to view page" do
      sign_in @user
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      user = User.create! valid_attributes
      get :show, params: { id: user.to_param }
      expect(response).to be_success
    end

    it "should allow normal user to view his page" do
      sign_in @user
      get :show, params: {id: @user.to_param}
      expect(response).to be_success
    end

    it "should allow normal user to view the page of other users" do
      sign_in @user
      get :show, params: {id: @other_user.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    it "creates a new user with valid params" do
      sign_in @admin
      expect {
        post :create, params: { user: valid_attributes }
      }.to change(User, :count).by(1)
      User.where(first_name: valid_attributes[:first_name])[0].destroy
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { first_name: valid_attributes[:first_name] + "_new",
          current_password: valid_attributes[:password] }
      }

      it "updates the requested user" do
        user = User.create! valid_attributes
        sign_in user
        put :update, params: { id: user.to_param, user: new_attributes }
        user.reload
        expect(user.first_name).to eq(new_attributes[:first_name])
      end

      it "should not allow normal user to update other accounts" do
        sign_in @user
        put :update, params: {id: @other_user.to_param, user: valid_attributes}
        expect(response).to be_forbidden
      end
    end
  end

  describe "DELETE #destroy" do
    it "should not allow normal user to destroy other users" do
      sign_in @user
      delete :destroy, params: {id: @other_user.to_param}
      expect(response).to be_forbidden
    end

    it "should allow normal users to destroy theirselves" do
      sign_in @user
      delete :destroy, params: {id: @user.to_param}
      expect(response).to redirect_to(root_url)
    end
  end

  describe "GET #edit" do
    it "should not allow normal user to edit other users" do
      sign_in @user
      get :edit, params: {id: @other_user.to_param}
      expect(response).to be_forbidden
    end

    it "should allow normal users to edit theirselves" do
      sign_in @user
      get :edit, params: {id: @user.to_param}
      expect(response).to be_success
    end
  end

end
