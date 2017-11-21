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
      it 'should redirect to the user dashboard' do
        get :hpiopenid
        expect(response).to redirect_to(dashboard_user_path(@user))
      end
    end

    context 'given an unlinked, logged in user' do
      it 'should link the accounts' do
        @user.uid = nil
        @user.provider = nil
        @user.save!
        sign_in @user
        get :hpiopenid
        @user.reload
        expect(response).to redirect_to(user_path(@user))
        expect(@user.uid).to eq(@autohash.uid)
        expect(@user.provider).to eq(@autohash.provider)
      end

      it 'should not link the accounts when the omniauth is already used' do
        @user2 = FactoryBot.create(:user)
        sign_in @user2
        get :hpiopenid
        @user.reload
        expect(response).to redirect_to(user_path(@user2))
        expect(@user2.uid).to be_nil
        expect(@user2.provider).to be_nil
      end
    end

    context 'given an linked, logged in user' do
      it 'should not change the users omniauth' do
        sign_in @user
        @request.env['omniauth.auth'] = OmniAuth::AuthHash.new(
          provider: @user.provider + '*',
          uid: @user.uid + '*',
          info: { email: @user.email }
        )
        get :hpiopenid
        expect(response).to redirect_to(user_path(@user))
        expect(@user.uid).to eq(@autohash.uid)
        expect(@user.provider).to eq(@autohash.provider)
      end
    end

    context 'given no (logged in or linked) user' do
      it 'should redirect to the root path' do
        @user.uid = nil
        @user.provider = nil
        @user.save!
        get :hpiopenid
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
