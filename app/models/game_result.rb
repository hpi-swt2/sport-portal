# == Schema Information
#
# Table name: game_results
#
#  id                    :integer          not null, primary key
#  score_home            :integer
#  score_away            :integer
#  match_id              :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  scores_proposed_by_id :integer
#

class GameResult < ApplicationRecord
  belongs_to :match

  validates :score_home, :score_away, numericality: { only_integer: true, greather_than_or_equal_to: 0 }, allow_nil: true
end
