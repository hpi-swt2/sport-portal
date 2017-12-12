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
    round = { 0 => 'Finalspiel', 1 => 'Halbfinalspiel', 2 => 'Viertelfinalspiel', 3 => 'Achtelfinalspiel' }[depth]
    if round == nil
      round = 'Vorrunde ' + (gameday + 1).to_s + ' - Spiel'
    end
    round + ' ' + index.to_s
  end
end
