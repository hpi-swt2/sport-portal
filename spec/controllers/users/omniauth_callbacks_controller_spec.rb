require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  describe 'GET #hpiopenid' do
    before :each do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      @user = FactoryBot.create(:user, uid: '1234567890', provider: 'hpiopenid')
      @autohash = OmniAuth::AuthHash.new(
        provider: @user.provider,
        uid: @user.uid,
        info: { email: @user.email }
      )
      @request.env['omniauth.auth'] = @autohash
    end

    context 'given a linked user' do
      it 'should return a success response' do
        get :hpiopenid
        expect(response).to be_success
      end
    end

    context 'given an unlinked, logged in user' do
      it 'should return a success response' do
        @user.uid = nil
        @user.provider = nil
        @user.save!
        sign_in @user
        get :hpiopenid
        expect(response).to redirect_to(user_path(@user))
      end
    end

    context 'given no (logged in or linked) user' do
      it 'should return a failure' do
        @user.uid = nil
        @user.provider = nil
        @user.save!
        get :hpiopenid
        expect(response).to have_http_status(:error)
      end
    end
  end

  describe 'GET #failure' do
    it 'should redirect to the welcome page' do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      get :failure
      expect(response).to redirect_to(root_path)
    end
  end
end
