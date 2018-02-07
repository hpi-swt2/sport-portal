# == Schema Information
#
# Table name: matches
#
#  id                    :integer          not null, primary key
#  place                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  team_home_id          :integer
#  team_away_id          :integer
#  event_id              :integer
#  points_home           :integer
#  points_away           :integer
#  gameday_number        :integer
#  team_home_type        :string           default("Team")
#  team_away_type        :string           default("Team")
#  index                 :integer
#  gameday_id            :integer
#  scores_proposed_by_id :integer
#  start_time            :datetime
#

FactoryBot.define do
  factory :match do
    sequence(:place) { |n| "Place #{n}" }
    association :team_away, factory: :team
    association :team_home, factory: :team
    association :event, factory: :event
    association :gameday, factory: :gameday
    gameday_number 1
    points_away 3
    points_home 1
    start_time DateTime.now

    transient do
      result_count 1
    end

    trait :with_results do
      after(:create) do |match, evaluator|
        create_list(:game_result, evaluator.result_count, match: match)
        match.reload
      end
    end

    trait :empty_points do
      points_away nil
      points_home nil
    end

    trait :with_tournament do
      association :event, factory: :tournament
    end
  end

  trait :confirmed do
    scores_proposed_by nil
  end

  trait :not_confirmed do
    scores_proposed_by { FactoryBot.create(:user) }
  end

end
