Given /^a league with gamemode (.*)$/ do |mode|
  create_league game_mode: League.game_modes[mode.to_sym]
end
