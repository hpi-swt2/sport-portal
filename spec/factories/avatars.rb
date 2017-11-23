# == Schema Information
#
# Table name: avatars
#
#  id           :integer          not null, primary key
#  image_data   :text
#  user_id      :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryBot.define do
  factory :avatar do
    image { File.open("#{Rails.root}/spec/fixtures/valid_avatar.png") }
    user
  end

  factory :large_file_avatar, class: Avatar do
    image { File.open("#{Rails.root}/spec/fixtures/some_file.bin") }
    user
  end
end
