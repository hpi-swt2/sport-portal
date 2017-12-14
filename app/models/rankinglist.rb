class Rankinglist < Event
  validates :deadline, :startdate, :enddate, presence: false
  validates :player_type, presence: false

  enum game_modes: [:elo, :win_loss, :true_skill]
end
