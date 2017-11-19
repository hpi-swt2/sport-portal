FactoryBot.define do
    factory :event do
        sequence(:name) { |n| "name#{n}" }
        sequence(:description) { |n| "description#{n}" }
        sequence(:discipline) { |n| "discipline#{n}" }
        player_type Event.player_types[Event.player_types.keys.sample]
        max_teams { rand(1..30) }
    end
end
