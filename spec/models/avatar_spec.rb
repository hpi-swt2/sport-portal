require 'rails_helper'

RSpec.describe Avatar, type: :model do
  it 'is valid with image as avatar' do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it 'is not valid with any other file type than image' do
    user = FactoryBot.build(:user)
    user.avatar = File.new("/tmp/something.bin")
    expect(user).not_to be_valid
  end

  it 'is not valid with an avatar of size >2mb' do
    user = FactoryBot.build(:user)
    expect(user).not_to be_valid
  end
end
