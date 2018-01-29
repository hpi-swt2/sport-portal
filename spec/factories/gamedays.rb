FactoryBot.define do
  factory :gameday do
    description "MyString"
    starttime "2018-01-21 00:43:47"
    endtime "2018-01-21 00:43:47"
    association :event, factory: :event

    trait :with_matches do
      transient do
        match_count 5
      end
      after(:create) do |gameday, evaluator|
        FactoryBot.create_list(:match, evaluator.match_count, gameday: gameday)
      end
    end
  end
end
