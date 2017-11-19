FactoryBot.define do
    factory :league do
        sequence(:name) { |n| "name#{n}" }
        sequence(:description) { |n| "description#{n}" }
        sequence(:discipline) { |n| "discipline#{n}" }
        game_mode League.game_modes[League.game_modes.keys.sample]
        player_type Event.player_types[Event.player_types.keys.sample]
        max_teams { rand(1..30) }
    end
end
