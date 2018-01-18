# For schema information see Event

class Rankinglist < Event
  validates :deadline, :startdate, :enddate, presence: false

  after_create :set_playertype_single

  def set_playertype_single
    self.player_type = :single
  end
  enum game_mode: [:elo, :win_loss, :true_skill]
end
