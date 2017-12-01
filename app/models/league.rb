class League < Event
  enum game_modes: [:round_robin, :two_halfs, :swiss, :danish]
end
