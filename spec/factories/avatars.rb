FactoryBot.define do
  factory :avatar do
    image { File.open("#{Rails.root}/spec/fixtures/valid_avatar.png") }
  end
end
