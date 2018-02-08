# == Schema Information
#
# Table name: matches
#
#  id             :integer          not null, primary key
#  place          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  team_home_id   :integer
#  team_away_id   :integer
#  event_id       :integer
#  points_home    :integer
#  points_away    :integer
#  gameday_number :integer
#  team_home_type :string           default("Team")
#  team_away_type :string           default("Team")
#  index          :integer
#  gameday_id     :integer
#  start_time     :datetime
#

class Match < ApplicationRecord
  belongs_to :team_home, polymorphic: true
  belongs_to :team_away, polymorphic: true
  belongs_to :event
  has_many :game_results, dependent: :destroy
  belongs_to :gameday, optional: true

  accepts_nested_attributes_for :game_results, allow_destroy: true
  has_many :match_results, dependent: :destroy

  after_create :send_mails_when_scheduled
  after_destroy :send_mails_when_canceled
  after_update :send_mails_when_date_changed, if: :saved_change_to_start_time?

  def send_mails_when_date_changed
    players = self.all_players
    players.each do |user|
      MatchMailer.send_mail(user, self, :match_date_changed).deliver_now
    end
  end

  def send_mails_when_scheduled
    players = self.all_players
    players.each do |user|
      MatchMailer.send_mail(user, self, :match_scheduled).deliver_now
    end
  end

  def send_mails_when_canceled
    players = self.all_players
    players.each do |user|
      MatchMailer.send_mail(user, self, :match_canceled).deliver_now
    end
  end

  validates :points_home, :points_away, numericality: { allow_nil: true }

  extend TimeSplitter::Accessors
  split_accessor :start_time, default: ->{Time.zone.now}

  before_create :set_default_start_time

  def set_default_start_time
    self.start_time = Time.now if self.start_time.blank?
  end

  @@has_winner_strategy = { "most_sets" => lambda { |match| match.wins_home != match.wins_away } }
  @@winner_strategy = { "most_sets" => lambda { |match| (match.wins_home > match.wins_away ? match.team_home_recursive : match.team_away_recursive) if match.has_winner? } }
  @@loser_strategy = { "most_sets" => lambda { |match| (match.wins_home < match.wins_away ? match.team_home_recursive : match.team_away_recursive) if match.has_winner? } }

  def depth
    event.finale_gameday - gameday_number
  end

  def round
    key = { 0 => 'zero', 1 => 'one', 2 => 'two', 3 => 'three' }[depth]
    key ||= 'other'
    I18n.t('matches.round_name.' + key, round: (gameday_number + 1).to_s, gameid: index.to_s)
  end

  def score_home_total
    game_results.inject(0) { |sum, result| sum + result.score_home }
  end

  def score_away_total
    game_results.inject(0) { |sum, result| sum + result.score_away }
  end

  def select_results_by_score(score_comparison)
    game_results.select { |current_result| (current_result.score_home.nil? || current_result.score_away.nil?) ? false : current_result.score_home.send(score_comparison, current_result.score_away) }
  end

  def wins_home
    select_results_by_score(:>).length
  end

  def wins_away
    select_results_by_score(:<).length
  end

  def has_points?
    points_home.present? && points_away.present?
  end

  def opponent_of(participant)
    home = team_home_recursive
    away = team_away_recursive
    return home if participant == away
    return away if participant == home
  end

  def has_scores?
    game_results.each do |result|
      if result.score_home.present? && result.score_away.present?
        return true
      end
    end
    false
  end

  def has_winner?
    @@has_winner_strategy[event.game_winrule].call(self)
  end

  def winner
    @@winner_strategy[event.game_winrule].call(self)
  end

  def loser
    @@loser_strategy[event.game_winrule].call(self)
  end

  def team_home_recursive
    team_home.advancing_participant
  end

  def team_away_recursive
    team_away.advancing_participant
  end

  def is_team_recursive?(team)
    team_home_recursive == team || team_away_recursive == team
  end

  def standing_string_of(team)
    match_name = round
    if loser == team
      return I18n.t 'events.overview.out', match_name: match_name
    end
    I18n.t 'events.overview.in', match_name: match_name
  end

  def last_match_of(team)
    if is_team_recursive? team
      return self
    end
    team_home.last_match_of(team) || team_away.last_match_of(team)
  end

  def adjust_index_by(offset)
    self.index -= offset
    save!
  end

  def set_points(home, away)
    self.points_home = home
    self.points_away = away
  end

  def calculate_points
    if !has_scores?
      set_points(nil, nil)
    elsif wins_home > wins_away
      set_points(event.points_for_win, event.points_for_lose)
    elsif wins_home < wins_away
      set_points(event.points_for_lose, event.points_for_win)
    else
      set_points(event.points_for_draw, event.points_for_draw)
    end
  end

  def save_with_point_calculation
    calculate_points
    save
  end

  def update_with_point_recalculation(attributes)
    winner_before = winner
    loser_before = loser
    success = update(attributes)

    if success && (winner != winner_before || loser != loser_before)
      calculate_points
      success = success && save
    end

    success
  end

  def all_players
    team_home = self.team_home
    team_away = self.team_away
    players = (team_home.is_a?(Team) ? team_home.members : []) + (team_away.is_a?(Team) ? team_away.members : [])
  end

  def has_result?
    has_scores? && has_points?
  end

  def apply_elo
    home_participant = Participant.where("team_id = ? AND event_id = ?", team_home_id, event).first
    away_participant = Participant.where("team_id = ? AND event_id = ?", team_away_id, event).first
    match_elo_result = get_match_elo_result(home_participant.team, away_participant.team)
    home_participant.update_elo_for(match_elo_result, away_participant)
  end

  def get_match_elo_result(home, away)
    case winner
    when home
      match_elo_result = 1.0
    when away
      match_elo_result = 0.0
    else
      match_elo_result = 0.5
    end
    match_elo_result
  end

  def teams
    [team_home, team_away]
  end
end
