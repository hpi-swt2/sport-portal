class Tournament < Event
  enum game_modes: [:ko, :ko_group, :double_elimination]

  # validates :name, :discipline, :game_mode, presence: true
end
