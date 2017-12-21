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
    match.name
  end

  def last_match_of(team)
    match.last_match_of team
  end

  def advancing_participant
    if winner_advances
      match.winner
    else
      match.loser
    end
  end
end
