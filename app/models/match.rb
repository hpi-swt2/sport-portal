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

  def name
    round
  end

  def depth
    event.max_match_level - gameday
  end

  def round
    round = { 0 => I18n.t('matches.finale_game', gameid: index.to_s), 1 => I18n.t('matches.semifinale_game', gameid: index.to_s), 2 => I18n.t('matches.quarterfinale_game', gameid: index.to_s), 3 => I18n.t('matches.eighthfinale_game', gameid: index.to_s) }[depth]
    if round == nil
      round = I18n.t('matches.preliminaries_game', round: (gameday + 1).to_s, gameid: index.to_s)
    end
    round
  end

  def winner
    if points_home != nil && points_away != nil && points_home != points_away
      winner_team_or_match = points_home > points_away ? team_home : team_away
      if winner_team_or_match.is_a? Team
        return winner_team_or_match
      end
      winner_team_or_match.winner
    end
  end

  def loser
    if points_home != nil && points_away != nil && points_home != points_away
      loser_team_or_match = points_home < points_away ? team_home : team_away
      if loser_team_or_match.is_a? Team
        return loser_team_or_match
      end
      loser_team_or_match.loser
    end
  end
end
