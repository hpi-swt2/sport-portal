class League < Event
  enum game_modes: [:round_robin, :two_halfs, :swiss, :danish]

  validates :name, :discipline, :game_mode, presence: true
end
