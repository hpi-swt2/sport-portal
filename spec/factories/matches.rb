# == Schema Information
#
# Table name: matches
#
#  id           :integer          not null, primary key
#  place        :string
#  score_home   :integer
#  score_away   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  team_home_id :integer
#  team_away_id :integer
#  event_id     :integer
#  points_home  :integer
#  points_away  :integer
#  gameday      :integer
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
    start_time Time.now

    trait :with_tournament do
      association :event, factory: :tournament
    end
  end
end
