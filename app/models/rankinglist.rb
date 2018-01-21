# == Schema Information
#
# Table name: events
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  discipline       :string
#  player_type      :integer          not null
#  max_teams        :integer
#  game_mode        :integer          not null
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  startdate        :date
#  enddate          :date
#  deadline         :date
#  gameday_duration :integer
#  owner_id         :integer
#  initial_value    :float
#  selection_type   :integer          default("fcfs"), not null
#

# For schema information see Event

class Rankinglist < Event
  validates :deadline, :startdate, :enddate, presence: false

  player_type = Event.player_types[:single]
  enum game_mode: [:elo, :win_loss, :true_skill]
end
