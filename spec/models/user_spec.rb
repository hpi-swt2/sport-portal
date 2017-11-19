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
  it "is valid when produced by a factory" do
	user = FactoryBot.build(:user)
	expect(user).to be_valid
  end

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
