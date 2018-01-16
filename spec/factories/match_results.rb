FactoryBot.define do
  factory :match_result do
    association :match, factory: :match
    winner_advances true
  end
end
