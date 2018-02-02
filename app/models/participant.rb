# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  event_id             :integer
#  team_id              :integer
#  rating               :float
#  created_at           :datetime         not null
#  updated_at           :datetime         not null

class Participant < ApplicationRecord
  belongs_to :team
  belongs_to :event

  def update_elo_for(match_result, opponent)
    own_rating = rating
    opponent_rating = opponent.rating
    expectation = 1.0 / (1.0 + (10.0**((opponent_rating - own_rating) / 400.0)))
    self.update(rating: own_rating + 32.0 * (match_result - expectation))
    opponent.update(rating: opponent_rating + 32.0 * (expectation - match_result))
  end
end
