FactoryBot.define do
  factory :tournament, parent: :event, class: Tournament do
    game_mode :ko

    factory :tournament_with_teams, class: "Tournament", parent: :event_with_teams do
    end
  end
end
