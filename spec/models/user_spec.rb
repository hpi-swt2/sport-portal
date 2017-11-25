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
#  birthday               :date
#  telephone_number       :string
#  telegram_username      :string
#  favourite_sports       :string
#

require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid when produced by a factory" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end

  it "is valid with only first name, email and password" do
    user = User.new(first_name: "User", email: "user@example.com", password: "password")
    expect(user).to be_valid
  end

  it "correctly validates telephone number" do
    expect(FactoryBot.build(:user, telephone_number: "+00491766563")).not_to be_valid
    expect(FactoryBot.build(:user, telephone_number: "0049 177 499 372")).not_to be_valid
    expect(FactoryBot.build(:user, telephone_number: "0173XX17352")).not_to be_valid
    expect(FactoryBot.build(:user, telephone_number: "01731557326")).to be_valid
  end

  it "correctly validates birthday" do
    expect(FactoryBot.build(:user, birthday: Date.new(1995, 8, 25))).to be_valid
    expect(FactoryBot.build(:user, birthday: Time.now.to_date.tomorrow)).not_to be_valid
  end
end
