require 'rails_helper'

RSpec.describe Avatar, type: :model do
  it 'is valid with image as avatar' do
    avatar = FactoryBot.build(:avatar)
    expect(avatar).to be_valid
  end

  it 'is not valid with any other file type than image' do
    avatar = FactoryBot.build(:large_file_avatar)
    expect(avatar).not_to be_valid
    expect(avatar.errors[:image]).to include('isn\'t of allowed type (allowed types: image/jpeg, image/gif, image/png)')
  end

  it 'is not valid with an avatar of size >2mb' do
    avatar = FactoryBot.build(:large_file_avatar)
    expect(avatar).not_to be_valid
    expect(avatar.errors[:image]).to include('is too large (max is 2 MB)')
  end
end
