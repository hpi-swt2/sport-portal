class Participant < ApplicationRecord
  belongs_to :team
  belongs_to :event

  def update_elo(match_result, opponent)
    own_rating = rating
    opponent_rating = opponent.rating
    expectation = 1.0 / (1.0 + (10.0**((opponent_rating - own_rating) / 200.0)))
    self.update(rating: own_rating + 15.0 * (match_result - expectation))
    opponent.update(rating: opponent_rating + 15.0 * (expectation - match_result))
  end
end
