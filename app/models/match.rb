# == Schema Information
#
# Table name: matches
#
#  id                  :integer          not null, primary key
#  place               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  team_home_id        :integer
#  team_away_id        :integer
#  event_id            :integer
#  points_home         :integer
#  points_away         :integer
#  gameday             :integer
#  team_home_type      :string           default("Team")
#  team_away_type      :string           default("Team")
#  index               :integer
#  start_time          :datetime
#  proposed_score_home :integer
#  proposed_score_away :integer
#  proposed_by_id      :integer
#  confirmed_by_id     :integer
#

class Match < ApplicationRecord
  belongs_to :team_home, polymorphic: true
  belongs_to :team_away, polymorphic: true
  belongs_to :event, dependent: :delete
  has_many :match_results, dependent: :destroy

  after_validation :calculate_points

  validates :points_home, :points_away, numericality: { allow_nil: true }

  def depth
    event.finale_gameday - gameday
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
    return if !has_scores? || has_points?

    if score_home > score_away
      set_points(3, 0)
    elsif score_home < score_away
      set_points(0, 3)
    else
      set_points(1, 1)
    end
  end

  def propose_scores(user, score_home, score_away)
    self.proposed_score_home = score_home
    self.proposed_score_away = score_away
    self.scores_proposed_by = user
  end

  def confirm_proposed_scores(user)
    return unless self.scores_proposed_by.team == user.team
    errors.add(:scores_confirmed_by, I18n.t('activerecord.models.match.errors.score_proposer_confirmer_team'))

    self.score_home = self.proposed_score_home
    self.score_away = self.proposed_score_away
    self.proposed_score_home = nil
    self.proposed_score_away = nil
  end

  def reject_proposed_scores(user)
    self.proposed_score_home = nil
    self.proposed_score_away = nil
  end
end
