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
  has_many :game_results, dependent: :delete_all

  accepts_nested_attributes_for :game_results, allow_destroy: true

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

  def select_results_by_score(score_comparison)
    game_results.select { |current_result| (current_result.score_home.nil? || current_result.score_away.nil?) ? false : send(score_comparison, current_result.score_home, current_result.score_away) }
  end

  def wins_home
    select_results_by_score(:>).length
  end

  def wins_away
    select_results_by_score(:<).length
  end

  def has_winner?
    wins_home != wins_away
  end

  def winner
    if has_winner?
      wins_home > wins_away
    end
  end

  def loser
    if has_winner?
      wins_home < wins_away
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
end
