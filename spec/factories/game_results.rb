FactoryBot.define do
  factory :game_result do
    score_home 1
    score_away 1
    association :match, factory: :match
  end
end
