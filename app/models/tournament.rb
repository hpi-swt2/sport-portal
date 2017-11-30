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

class Tournament < Event
  enum game_modes: [:ko, :ko_group, :double_elimination]

  validates :name, :discipline, :game_mode, presence: true
end
