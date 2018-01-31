# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  name                 :string
#  description          :text
#  discipline           :string
#  player_type          :integer          not null
#  max_teams            :integer
#  game_mode            :integer          not null
#  type                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  startdate            :date
#  enddate              :date
#  deadline             :date
#  gameday_duration     :integer
#  owner_id             :integer
#  initial_value        :float
#  selection_type       :integer          default("fcfs"), not null
#  min_players_per_team :integer
#  max_players_per_team :integer
#  matchtype            :integer
#  bestof_length        :integer          default(1)
#  game_winrule         :integer
#  points_for_win       :integer          default(3)
#  points_for_draw      :integer          default(1)
#  points_for_lose      :integer          default(0)
#  image_data           :text
#

class Rankinglist < Event
  validates :deadline, :startdate, :enddate, presence: false

  enum game_mode: [:elo, :win_loss, :true_skill]

  def update_rankings(match)
    if (game_mode == 'elo')
      elo_adjustments_of(match)
    end
  end

  def elo_adjustments_of(match)
    home_participant = Participant.where("team_id = ? AND event_id = ?", match.team_home_id, self).first
    away_participant = Participant.where("team_id = ? AND event_id = ?", match.team_away_id, self).first
    case match.winner
    when home_participant.team
      match_result = 1.0
    when away_participant.team
      match_result = 0.0
    else
      match_result = 0.5
    end
    home_participant.update_elo(match_result, away_participant)
  end

  before_validation do
    self.player_type = Event.player_types[:single]
    self.min_players_per_team = 1
    self.max_players_per_team = 1
  end
end
