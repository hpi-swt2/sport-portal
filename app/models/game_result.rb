class GameResult < ApplicationRecord
  belongs_to :match

  validates :score_home, :score_away, numericality: { only_integer: true, greather_than_or_equal_to: 0 }, allow_nil: true
end
