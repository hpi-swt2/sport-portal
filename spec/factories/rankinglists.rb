FactoryBot.define do
  factory :rankinglist, parent: :event, class: Rankinglist do
    game_mode Rankinglist.game_modes.keys.sample
    initial_value 1.3
    player_type Event.player_types[:single]

    factory :rankinglist_with_teams, class: "Rankinglist", parent: :event_with_teams do
    end
  end
end
