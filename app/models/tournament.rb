class Tournament < Event
    enum game_modes: [:ko, :ko_group, :double_elimination]
end
