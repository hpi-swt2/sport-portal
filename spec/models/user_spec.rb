# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  first_name             :string
#  last_name              :string
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is valid when produced by a factory' do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it 'is not valid when the omniauth is not unique' do
    user1 = FactoryBot.create(:user, provider: 'mock', uid: '1234567890')
    user2 = FactoryBot.build(:user, provider: 'mock', uid: '1234567890')
    expect(user2).to_not be_valid
  end

  it 'is valid when the omniauth is nil' do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.build(:user)
    expect(user2).to be_valid
  end

  describe 'self#from_omniauth' do
    it 'should return an existing user' do
      user = FactoryBot.create :user, provider: 'mock', uid: '1234567890'
      authhash = OmniAuth::AuthHash.new(provider: 'mock', uid: '1234567890')
      expect(User.from_omniauth(authhash).id).to eq(user.id)
    end

    it 'should return a new user without an existing user' do
      user = FactoryBot.create :user
      authhash = OmniAuth::AuthHash.new(provider: 'mock', uid: '1234567890', info: { email: 'test@test.com' })
      new_user = User.from_omniauth authhash
      expect(new_user).to_not be_nil
      expect(new_user.persisted?).to be false
    end
  end

  describe 'self#new_with_session' do
    it 'should copy parameters from the given omniauth' do
      session = {
        'uid' => '1234567890',
        'provider' => 'mock',
        'email' => 'm@ex.com',
        'expires' => Time.current + 10.minutes
      }
      user = User.new_with_session({}, { 'omniauth.data' => session })
      expect(user.email).to eq('m@ex.com')
      expect(user.provider).to eq(session['provider'])
      expect(user.uid).to eq(session['uid'])
    end

    it 'should ignore expired auth data' do
      session = {
        'uid' => '1234567890',
        'provider' => 'mock',
        'email' => 'm@ex.com',
        'expires' => Time.current - 2.minutes
      }
      user = User.new_with_session({}, { 'omniauth.data' => session })
      expect(user.email).to_not eq('m@ex.com')
      expect(user.provider).to_not eq(session['provider'])
      expect(user.uid).to_not eq(session['uid'])
    end

    it 'should ignore an empty session' do
      user = User.new_with_session({}, {})
      expect(user).to_not be_nil
      expect(user.provider).to be_nil
      expect(user.uid).to be_nil
    end
  end

  describe '#has_omniauth' do
    it 'should return return true iff the user has an omniauth provider and uid' do
      user = FactoryBot.create :user, provider: 'mock', uid: '1234567890'
      expect(user.has_omniauth?).to be true
    end

    it 'should return return false if the user does not have a provider or a uid' do
      user = FactoryBot.create :user
      expect(user.has_omniauth?).to be false
      user.uid = '10'
      expect(user.has_omniauth?).to be false
      user.uid = nil
      user.provider = 'mock'
      expect(user.has_omniauth?).to be false
    end
  end

  describe '#omniauth=' do
    it 'should set the omniauth' do
      auth = double()
      expect(auth).to receive(:uid).and_return('1234567890')
      expect(auth).to receive(:provider).and_return('mock')
      user = FactoryBot.create :user
      user.omniauth = auth
      expect(user.uid).to eq('1234567890')
      expect(user.provider).to eq('mock')
    end
  end

  describe '#reset_omniauth' do
    it 'should reset the omniauth' do
      user = FactoryBot.create :user, provider: 'mock', uid: '1234567890'
      user.reset_omniauth
      expect(user.uid).to be_nil
      expect(user.provider).to be_nil
    end
  end

  it "should have an attribute events" do
    @relation = User.reflect_on_association(:events)
    expect(@relation.macro).to eq :has_and_belongs_to_many
  end

  it "has the admin attribute" do
    user = FactoryBot.build(:user)
    expect(user).to have_attributes(:admin => false)
  end

  it "has the admin attribute set to true, if it is an admin" do
    admin = FactoryBot.build(:admin)
    expect(admin.admin).to eq(true)
  end

  it "has the admin attribute set to false, if it is not an admin" do
    user = FactoryBot.build(:user)
    expect(user.admin).to eq(false)
  end
end
