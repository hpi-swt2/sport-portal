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
      @request.env['devise.mapping'] = Devise.mappings[:user]
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

  describe 'GET #show' do
    it 'returns a success response' do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = User.create! valid_attributes
      get :show, params: { id: user.to_param }
      expect(response).to be_success
    end

    it "should allow normal user to view his page" do
      sign_in @user
      get :show, params: { id: @user.to_param }
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    before :each do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @auth_session = {
          'provider' => 'mock',
          'uid' => '1234567890',
          'email' => 'test@potato.com',
          'expires' => Time.current + 10.minutes
      }
    end

    it 'should not set the email when no auth session is provided' do
      get :new
      user = @controller.user
      expect(response).to be_success
      expect(user.email).to be_blank
    end

    it 'should set the email when an auth session is provided' do
      @request.session['omniauth.data'] = @auth_session
      get :new
      user = @controller.user
      expect(response).to be_success
      expect(user.email).to eq(@auth_session['email'])
    end

    it 'should not set the email when an expired auth session is provided' do
      @auth_session['expires'] = Time.current - 2.minutes
      @request.session['omniauth.data'] = @auth_session
      get :new
      user = @controller.user
      expect(response).to be_success
      expect(user.email).to be_blank
    end
  end

  describe 'GET #edit' do
    before :each do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = User.create! valid_attributes
    end

    it 'should show the edit page when the user is logged in' do
      sign_in @user
      get :edit, params: { id: @user.to_param }
      expect(response).to be_success
    end

    it 'should redirect to the sign in page when no user is logged in' do
      get :edit, params: { id: @user.to_param }
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "POST #create" do
    it "creates a new user with valid params" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      expect {
        post :create, params: { user: valid_attributes }
      }.to change(User, :count).by(1)
    end

    it "should allow normal user to view the page of other users" do
      sign_in @user
      get :show, params: { id: @other_user.to_param }
      expect(response).to be_success
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { first_name: valid_attributes[:first_name] + '_new',
         current_password: valid_attributes[:password] }
      }

      it 'updates the requested user' do
        @request.env['devise.mapping'] = Devise.mappings[:user]
        user = User.create! valid_attributes
        sign_in user
        put :update, params: { id: user.to_param, user: new_attributes }
        user.reload
        expect(user.first_name).to eq(new_attributes[:first_name])
      end
    end
  end

  describe 'GET #link' do
    before :each do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = User.create! valid_attributes
    end

    context 'given a logged in user' do
      it 'should redirect to OpenID' do
        sign_in @user
        get :link, params: { id: @user.to_param }
        expect(response).to redirect_to(user_hpiopenid_omniauth_authorize_path)
      end
    end

    context 'given no logged in user' do
      it 'should deny access' do
        get :link, params: { id: @user.to_param }
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'GET #unlink' do
    before :each do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = User.create! valid_attributes
    end

    context 'given a logged in user with omniauth' do
      it 'should unlink the account' do
        @user.uid = '1234567890'
        @user.provider = 'mock'
        @user.save!
        sign_in @user
        get :unlink, params: { id: @user.to_param }
        @user.reload
        expect(response).to redirect_to(user_path(@user))
        expect(@user.uid).to be_nil
        expect(@user.provider).to be_nil
      end
    end

    context 'given a logged in user without omniauth' do
      it 'should redirect to the users page' do
        sign_in @user
        get :unlink, params: { id: @user.to_param }
        expect(response).to redirect_to(user_path(@user))
      end
    end

    context 'given no logged in user' do
      it 'should deny access' do
        get :unlink, params: { id: @user.to_param }
        expect(response).to be_unauthorized
      end
    end
  end

  describe "DELETE #destroy" do
    it "should allow normal users to destroy theirselves" do
      sign_in @user
      delete :destroy, params: { id: @user.to_param }
      expect(response).to redirect_to(root_url)
    end
  end

  describe "GET #edit" do
    it "should allow normal users to edit theirselves" do
      sign_in @user
      get :edit, params: { id: @user.to_param }
      expect(response).to be_success
    end
  end

end
