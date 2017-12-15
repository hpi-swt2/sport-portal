module EventsHelper
  def league_gamemodes_localize
    Hash[League.game_modes.map { |key, value| [key, I18n.t("events.gamemode.#{key}")] }]
  end

  def tournament_gamemodes_localize
    Hash[Tournament.game_modes.map { |key, value| [key, I18n.t("events.gamemode.#{key}")] }]
  end

  def event_player_types_localize
    Hash[Event.player_types.map { |key, value| [key, I18n.t("activerecord.attributes.event.player_types.#{key}")] }]
  end

  def rankinglist_gamemodes_localize
    Hash[Rankinglist.game_modes.map { |key, value| [key, I18n.t("events.gamemode.#{key}")] }]
  end
end
