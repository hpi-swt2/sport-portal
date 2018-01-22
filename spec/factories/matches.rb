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
#  start_time     :datetime
#

FactoryBot.define do
  factory :match do
    sequence(:place) { |n| "Place #{n}" }
    association :team_away, factory: :team
    association :team_home, factory: :team
    association :event, factory: :event
    score_home { rand(10..20) }
    score_away { rand(1..9) }
    gameday 1
    points_away 3
    points_home 1

    trait :empty_points do
      points_away nil
      points_home nil
    end

    trait :with_home_winning do
      points_away 0
      points_home 3
      score_away 0
      score_home 3
    end

    trait :with_tournament do
      association :event, factory: :tournament
    end
  end
end
