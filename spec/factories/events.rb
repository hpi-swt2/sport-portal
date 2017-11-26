# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  gamemode    :string
#  sport       :string
#  teamsport   :boolean
#  playercount :integer
#  gamesystem  :text
#  deadline    :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  startdate   :date
#  enddate     :date
#

FactoryBot.define do
  factory :event do
    name "HPI-Tischtennis-Liga"
    description "Tischtennis spielen am HPI"
    gamemode "Best of five"
    sport "Tischtennis"
    teamsport false
    playercount 1
    gamesystem "Schweizer System"
    deadline Date.new(2017,11,16)
    startdate Date.new(2017,12,01)
    enddate Date.new(2017,12,05)
  end
end
