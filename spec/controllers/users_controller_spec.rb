require 'rails_helper'

# There are no expectations of assigns and templates rendered in this spec.
# These features have been removed from Rails core in Rails 5, but can be
# added back in via the `rails-controller-testing` gem.

RSpec.describe UsersController, type: :controller do
  mock_devise

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    FactoryBot.attributes_for(:user)
  }

  let(:invalid_attributes) {
    FactoryBot.attributes_for(:user, last_name: nil)
  }

  before(:each) do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:admin)
  end

  after(:each) do
    @user.destroy
    @other_user.destroy
    @admin.destroy
  end

  describe "GET #index" do

    it "should not allow normal user to view page" do
      sign_in @user
      get :index, params: {}
      expect(response).to be_forbidden
    end

    it "should allow admin to view page" do
      sign_in @admin
      get :index, params: {}
      expect(response).to be_success
    end

  end

  describe 'GET #show' do
    it "should allow normal user to view his page" do
      sign_in @user
      get :show, params: { id: @user.to_param }
      expect(response).to be_success
    end
    it "should allow another user to view his page" do
      sign_in @user
      get :show, params: { id: @other_user.to_param }
      expect(response).to be_success
    end
    it "should allow an admin to view his page" do
      sign_in @admin
      get :show, params: { id: @user.to_param }
      expect(response).to be_success
    end
  end

  describe 'GET #new' do
    before :each do
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

  describe 'GET #dashboard' do
    it "should not show user's dashboard to not logged in user" do
      get :dashboard, params: { id: @user.to_param }
      expect(response).to be_unauthorized
    end

    it "should not show admin's dashboard to not logged in user" do
      get :dashboard, params: { id: @admin.to_param }
      expect(response).to be_unauthorized
    end

    it 'should allow user to view their dashboard' do
      sign_in @user
      get :dashboard, params: { id: @user.to_param }
      expect(response).to be_success
    end

    it "should disallow user to view other user's dashboard" do
      sign_in @user
      get :dashboard, params: { id: @other_user.to_param }
      expect(response).to be_forbidden
    end

    it "should disallow user to view admin's dashboard" do
      sign_in @user
      get :dashboard, params: { id: @admin.to_param }
      expect(response).to be_forbidden
    end

    it 'should allow admin to view their dashboard' do
      sign_in @admin
      get :dashboard, params: { id: @admin.to_param }
      expect(response).to be_success
    end

    it "should allow admin to view every user's dashboard" do
      sign_in @admin
      get :dashboard, params: { id: @user.to_param }
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    it "creates a new user with valid params" do
      expect {
        post :create, params: { user: valid_attributes }
      }.to change(User, :count).by(1)
    end

    it 'sends a mail confirmation mail to new users' do
      mock_confirmation_mail = double
      expect(Devise.mailer).to receive(:confirmation_instructions).and_return(mock_confirmation_mail)
      expect(mock_confirmation_mail).to receive(:deliver)
      post :create, params: { user: valid_attributes }
    end

    it 'sends no mail confirmation mail to new omniauth users' do
      expect(Devise.mailer).to_not receive(:confirmation_instructions)
      FactoryBot.build(:user, :with_openid).save!
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) {
        { first_name: valid_attributes[:first_name] + '_new',
         current_password: valid_attributes[:password] }
      }

      let(:new_admin_attributes) {
        { first_name: valid_attributes[:first_name] + '_new' }
      }

      it 'updates the requested user' do
        user = User.create! valid_attributes
        sign_in user
        put :update, params: { id: user.to_param, user: new_attributes }
        user.reload
        expect(user.first_name).to eq(new_attributes[:first_name])
      end

      it 'should allow admin to update other users' do
        sign_in @admin
        put :update, params: { id: @user.to_param, user: new_admin_attributes }
        @user.reload
        expect(@user.first_name).to eq(new_admin_attributes[:first_name])
      end
    end

    context 'with invalid params' do
      it 'as admin should be a success response' do
        sign_in @admin
        put :update, params: { id: @user.to_param, user: invalid_attributes }
        expect(response).to be_success
      end
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      user = User.create! valid_attributes
      sign_in user
      get :edit, params: { id: user.to_param }
      expect(response).to be_success
    end
  end

  describe "PUT #update_profile" do
    context "with valid params" do
      let(:new_attributes) {
        { birthday: valid_attributes[:birthday] + 1.year,
          telephone_number: "01766668734",
          telegram_username: valid_attributes[:telegram_username] + "_new",
          favourite_sports: valid_attributes[:favourite_sports] + ", Riding" }
      }

      it "updates the requested user" do
        user = User.create! valid_attributes
        sign_in user
        id = user.id
        foo = new_attributes
        put :update, params: { id: id, user: foo }
        user.reload
        expect(user.birthday).to eq(new_attributes[:birthday])
        expect(user.telephone_number).to eq(new_attributes[:telephone_number])
        expect(user.telegram_username).to eq(new_attributes[:telegram_username])
        expect(user.favourite_sports).to eq(new_attributes[:favourite_sports])
      end
    end

    context "with invalid params" do
      it "rerenders the edit page with erors" do
        user = User.create! valid_attributes
        sign_in user
        new_attributes = { birthday: Date.today + 1.year }
        put :update, params: { id: user.to_param, user: new_attributes }
        expect(response).to render_template(:edit)
      end
    end

    context '(re)confirmable' do
      it 'should send a confirmation and a notification mail on email change' do
        user = User.create! valid_attributes
        sign_in user
        Devise.mailer.deliveries.clear

        new_mail = 'my_new_mail@example.com'
        new_attributes = { email: new_mail,
                           current_password: user.password }

        mock_confirmation_mail = double
        mock_notification_mail = double
        expect(Devise.mailer).to receive(:confirmation_instructions).and_return(mock_confirmation_mail)
        expect(Devise.mailer).to receive(:email_changed).and_return(mock_notification_mail)
        expect(mock_confirmation_mail).to receive(:deliver)
        expect(mock_notification_mail).to receive(:deliver)
        put :update, params: { id: user.to_param, user: new_attributes }
      end
    end
  end

  describe 'GET #link' do
    before :each do
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

  describe "GET #edit" do
    it "should allow normal users to edit themselves" do
      sign_in @user
      get :edit, params: { id: @user.to_param }
      expect(response).to be_success
    end
  end

  describe 'GET #notifications' do
    context 'given a logged in useer' do
      it 'should show notifications settings page successfully' do
        sign_in @user
        get :notifications, params: { id: @user.to_param }
        expect(response).to be_success
      end
    end
    context 'given no logged in user' do
      it 'should deny access' do
        get :notifications, params: { id: @user.to_param }
        expect(response).to be_unauthorized
      end
    end
  end

  describe 'PATCH #update_notifications' do
    it 'should update notifications settings successfully' do
      sign_in @user
      patch :update_notifications, params: { id: @user.to_param, user: { event_notifications_enabled: false, team_notifications_enabled: false } }
      @user.reload
      expect(@user.event_notifications_enabled?).to eq(false)
      expect(@user.team_notifications_enabled).to eq(false)
    end

    it 'redirect to notification settings' do
      sign_in @user
      patch :update_notifications, params: { id: @user.to_param, user: { event_notifications_enabled: false, team_notifications_enabled: false } }
      response.should redirect_to :notifications_user
    end
  end
end
