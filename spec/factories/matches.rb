# == Schema Information
#
# Table name: matches
#
#  id             :integer          not null, primary key
#  place          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  team_home_id   :integer
#  team_away_id   :integer
#  event_id       :integer
#  points_home    :integer
#  points_away    :integer
#  gameday        :integer
#  team_home_type :string           default("Team")
#  team_away_type :string           default("Team")
#  index          :integer
#

FactoryBot.define do
  factory :match do
    sequence(:place) { |n| "Place #{n}" }
    association :team_away, factory: :team
    association :team_home, factory: :team
    association :event, factory: :event
    gameday 1
    points_away 3
    points_home 1

    factory :match_with_results do
      after(:create) do |match|
        create_list(:game_result, 3, match: match)
      end
    end
  end

end
