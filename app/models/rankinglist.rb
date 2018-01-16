# For schema information see Event

class Rankinglist < Event
  validates :deadline, :startdate, :enddate, presence: false

  player_type = Event.player_types[:single]
  enum game_mode: [:elo, :win_loss, :true_skill]

  def can_join?(user)
    not has_participant?(user)
  end
end
