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
    winner_team = winner
    if winner_team != nil
      return winner_team.name
    end
    round
  end

  def depth
    event.max_match_level - gameday
  end

  def round
    key = case depth
          when 0 then 'zero'
          when 1 then 'zero'
          when 2 then 'zero'
          when 3 then 'zero'
          else 'other'
    end
    I18n.t('matches.round_name.' + key, round: (gameday + 1).to_s, gameid: index.to_s)
  end

  def has_winner?
    points_home != nil && points_away != nil && points_home != points_away
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
end
