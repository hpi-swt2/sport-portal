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

  describe '#from_omniauth' do
    it 'should return an existing user' do
      user = FactoryBot.create :user, provider: 'mock', uid: '1234567890'
      autohash = OmniAuth::AuthHash.new(provider: 'mock', uid: '1234567890')
      expect(User.from_omniauth(autohash).id).to eq(user.id)
    end

    it 'should create a new user when a new autohash is given' do
      autohash = OmniAuth::AuthHash.new(provider: 'mock', uid: '1234567890')
      user = User.from_omniauth autohash
      expect(user.persisted?).to eq(false)
    end
  end
end
