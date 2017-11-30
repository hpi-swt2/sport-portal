FactoryBot.define do
    factory :league, parent: :event do
        game_mode League.game_modes[League.game_modes.keys.sample]
        gameday_duration 7

        factory :league_with_teams, class: "League", parent: :event_with_teams do
        end
    end
end
