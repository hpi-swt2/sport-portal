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

  it "has the admin attribute" do
    user = FactoryBot.build(:user)
    expect(user).to have_attributes(:admin => false)
  end

  it "has the admin attribute set to true, if it is an admin" do
    admin = FactoryBot.build(:admin)
    expect(admin.admin).to eq(true)
  end

end
