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
#  provider               :string
#  uid                    :string
#  admin                  :boolean          default(FALSE)
#

FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "first_name#{n}" }
    sequence(:last_name) { |n| "last_name#{n}" }
    sequence(:email) { |n| "#{n}@example.com" }
    sequence(:password) { |n| "password#{n}" }
    sequence(:password_confirmation) { |n| "password#{n}" }
    birthday Date.new(1995, 10, 20)
    telephone_number "00491731117843"
    sequence(:telegram_username) { |n| "telegram_user#{n}" }
    favourite_sports "Football, Basketball, Tennis"
  end

  trait :with_avatar do
    after(:build) do |user|
      user.avatar = File.open("#{Rails.root}/spec/fixtures/valid_avatar.png")
    end
  end

  trait :with_large_avatar do
    after(:build) do |user|
      user.avatar = File.open("#{Rails.root}/spec/fixtures/some_file.bin")
    end
  end

  factory :admin, class: User, parent: :user do
    sequence(:email) { |n| "#{n}admin@example.com" }
    admin true
  end
end
