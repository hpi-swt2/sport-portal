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

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      # https://github.com/plataformatec/devise/wiki/How-To:-Test-controllers-with-Rails-3-and-4-%28and-RSpec%29#mappings
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = User.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = User.create! valid_attributes
      get :show, params: {id: user.to_param}, session: valid_session
      expect(response).to be_success
    end
  end
end
