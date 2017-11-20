require 'rails_helper'

RSpec.describe Avatar, type: :model do
  it 'is valid with image as avatar' do
    avatar = FactoryBot.build(:avatar)
    expect(avatar).to be_valid
  end

  it 'is not valid with any other file type than image' do
    avatar = FactoryBot.build(:avatar)
    avatar = File.new("/tmp/something.bin")
    expect(avatar).not_to be_valid
  end

  it 'is not valid with an avatar of size >2mb' do
    avatar = FactoryBot.build(:avatar)
    expect(avatar).not_to be_valid
  end
end
