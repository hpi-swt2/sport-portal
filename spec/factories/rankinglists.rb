FactoryBot.define do
  factory :rankinglist, parent: :event, class: :rankinglist do
    game_mode Rankinglist.game_modes[Rankinglist.game_modes.keys.sample]
    initial_value 1.3
    deadline nil
    startdate nil
    enddate nil
    player_type nil

    factory :rankinglist_with_teams, class: "Rankinglist", parent: :event_with_teams do
    end
  end
end
