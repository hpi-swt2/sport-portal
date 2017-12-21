# == Schema Information
#
# Table name: match_results
#
#  id               :integer          not null, primary key
#  match            :integer          (points to a Match Object)
#  winner_advances  :boolean
#

class MatchResult < ApplicationRecord
  belongs_to :match

  def name
    if knows_advancing_participant
      advancing_participant.name
    else
      description
    end
  end

  def description
    key = winner_advances ? 'matches.winner_of_match' : 'matches.loser_of_match'
    I18n.t key, match: match.round
  end

  def last_match_of(team)
    match.last_match_of team
  end

  def knows_advancing_participant
    advancing_participant.present?
  end

  def advancing_participant
    if winner_advances
      match.winner
    else
      match.loser
    end
  end
end
