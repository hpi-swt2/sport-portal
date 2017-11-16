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

FactoryBot.define do
  factory :user do
	sequence(:first_name) { |n| "first_name#{n}" }
	sequence(:last_name) { |n| "last_name#{n}" }
	sequence(:email) { |n| "#{n}@example.com" }
	sequence(:password) { |n| "password#{n}" }
	sequence(:password_confirmation) { |n| "password#{n}" }
	avatar { File.new("#{Rails.root}/spec/support/fixtures/valid_avatar.png") }
  end
end
