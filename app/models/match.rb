# == Schema Information
#
# Table name: matches
#
#  id           :integer          not null, primary key
#  place        :string
#  score_home   :integer
#  score_away   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  team_home_id :integer
#  team_away_id :integer
#  event_id     :integer
#  points_home  :integer
#  points_away  :integer
#  gameday      :integer
#

class Match < ApplicationRecord
  has_many :home_matches, as: :team_home, class_name: 'Match'
  has_many :away_matches, as: :team_away, class_name: 'Match'
  def matches
    home_matches.or away_matches
  end
  belongs_to :team_home, polymorphic: true
  belongs_to :team_away, polymorphic: true
  belongs_to :event, dependent: :delete

  after_validation :calculate_points

  def name
    winner_team = winner
    if winner_team.present?
      return winner_team.name
    end
    round
  end

  def depth
    event.max_match_level - gameday
  end

  def round
    key = { 0 => 'zero', 1 => 'one', 2 => 'two', 3 => 'three' }[depth]
    key ||= 'other'
    I18n.t('matches.round_name.' + key, round: (gameday + 1).to_s, gameid: index.to_s)
  end

  def has_points?
    points_home.present? && points_away.present?
  end

  def has_scores?
    score_home.present? && score_away.present?
  end

  def has_winner?
    has_points? && points_home != points_away
  end

  def winner
    if has_winner?
      points_home > points_away ? team_home_recursive : team_away_recursive
    end
  end

  def loser
    if has_winner?
      points_home < points_away ? team_home_recursive : team_away_recursive
    end
  end

  def team_home_recursive
    team_home.winner
  end

  def team_away_recursive
    team_away.winner
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

  def calculate_points
    return if !has_scores? || has_points?

    if score_home > score_away
      self.points_home = 3
      self.points_away = 0
    elsif score_home < score_away
      self.points_home = 0
      self.points_away = 3
    else
      self.points_home = 1
      self.points_away = 3
    end
  end
end
