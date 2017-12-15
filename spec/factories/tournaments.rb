FactoryBot.define do
  factory :tournament, parent: :event, class: Tournament do
    game_mode Tournament.game_modes[Tournament.game_modes.keys.sample]
    deadline { Date.current + 1 }
    startdate { Date.current + 2 }
    enddate { Date.current + 3 }

    factory :tournament_with_teams, class: "Tournament", parent: :event_with_teams do
    end
  end
end
