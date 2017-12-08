class Rankinglist < Event
  validates :discipline, :deadline, :startdate, :enddate, :player_type, presence: false
end
