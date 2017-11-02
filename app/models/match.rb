class Match < ApplicationRecord
  belongs_to :team_home
  belongs_to :team_away
end
