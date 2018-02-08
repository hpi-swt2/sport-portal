# == Schema Information
#
# Table name: participants
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  team_id    :integer
#  rating     :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :participant do
    event_id 1
    team_id 1
    rating 1
  end
end
