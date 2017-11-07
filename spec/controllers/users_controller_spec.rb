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

  describe "GET #index" do
    it "returns a success response" do
      # https://github.com/plataformatec/devise/wiki/How-To:-Test-controllers-with-Rails-3-and-4-%28and-RSpec%29#mappings
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = User.create! valid_attributes
      get :index, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = User.create! valid_attributes
      get :show, params: {id: user.to_param}
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    it "creates a new user with valid params" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      expect {
        post :create, params: {user: valid_attributes}
      }.to change(User, :count).by(1)
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {first_name: valid_attributes[:first_name] + "_new", current_password: valid_attributes[:password]}
      }

      it "updates the requested user" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user = User.create! valid_attributes
        sign_in user
        put :update, params: {id: user.to_param, user: new_attributes}
        user.reload
        expect(user.first_name).to eq(new_attributes[:first_name])
      end
    end
  end

end
