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

class League < Event
  enum game_modes: [:round_robin, :two_halfs, :swiss, :danish]

  validates :name, :discipline, :game_mode, :max_teams, presence: true
end
