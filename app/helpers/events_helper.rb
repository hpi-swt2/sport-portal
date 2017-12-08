module EventsHelper
  def event_types_enum_localize
    Hash[Event.types.map { |k,v| [k, I18n.t("events.#{k}")] }]
  end

  def league_gamemodes_localize
    Hash[League.game_modes.map { |k,v| [k, I18n.t("events.gamemode.#{k}")] }]
  end

  def tournament_gamemodes_localize
    Hash[Tournament.game_modes.map { |k,v| [k, I18n.t("events.gamemode.#{k}")] }]
  end

  def event_player_types_localize
    Hash[Event.player_types.map { |k,v| [k, I18n.t("activerecord.attributes.event.player_types.#{k}")] }]
  end

  def event_metric_localize
    Hash[Event.metrics.map { |k,v| [k, I18n.t("events.metric.#{k}")] }]
  end
end