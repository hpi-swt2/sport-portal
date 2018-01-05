FactoryBot.define do
  factory :tournament, parent: :event, traits: [:has_dates], class: Tournament do
    game_mode :ko

    factory :tournament_with_teams, class: Tournament, parent: :event_with_teams, traits: [:has_dates] do
      teams_count 4
      game_mode :ko
    end
  end
end
