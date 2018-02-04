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
  belongs_to :scores_proposed_by, class_name: 'User', optional: true

  def can_confirm_scores?(user)
    !(is_confirmed? || match.users_in_same_team(user, scores_proposed_by))
  end

  def is_confirmed?
    scores_proposed_by.blank?
  end

  def confirm_scores
    self.scores_proposed_by = nil
    save
  end
end
