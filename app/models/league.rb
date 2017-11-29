class League < Event
  enum game_modes: [:round_robin, :two_halfs, :swiss, :danish]

<<<<<<< HEAD
  # validates :name, :discipline, :game_mode, presence: true
=======
  validates :name, :discipline, :game_mode, :max_teams, presence: true
>>>>>>> dev
end
