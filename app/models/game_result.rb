# == Schema Information
#
# Table name: game_results
#
#  id         :integer          not null, primary key
#  score_home :integer
#  score_away :integer
#  match_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class GameResult < ApplicationRecord
  belongs_to :match

  validates :score_home, :score_away, numericality: { only_integer: true, greather_than_or_equal_to: 0 }, allow_nil: true
  belongs_to :scores_proposed_by, class_name: 'User', optional: true

  def can_confirm_scores?(user)
    # TODO: Dont let a random person propose scores
    !is_confirmed? && (match.team_home.members.include?(user) && match.team_away.members.include?(scores_proposed_by) ||
            match.team_away.members.include?(user) && match.team_home.members.include?(scores_proposed_by))
  end

  def is_confirmed?
    scores_proposed_by.nil?
  end

  def confirm_scores(user)
    if can_confirm_scores?(user)
      self.scores_proposed_by = nil
    else
      errors.add(:scores_proposed_by, I18n.t('activerecord.models.match.errors.score_proposer_confirmer_team'))
    end
    save
  end
end
