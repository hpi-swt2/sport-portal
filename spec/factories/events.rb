FactoryBot.define do
  factory :event do
    name "HPI-Tischtennis-Liga"
    description "Tischtennis spielen am HPI"
    gamemode "Best of five"
    sport "Tischtennis"
    teamsport false
    playercount 1
    gamesystem "Schweizer System"
    deadline "2017-11-16"
    startdate "2017-12-01"
  end
end
