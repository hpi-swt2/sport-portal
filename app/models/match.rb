class Match < ApplicationRecord
  belongs_to :team_home, class_name: 'Team', foreign_key: 'team_home_id'
  belongs_to :team_away, class_name: 'Team', foreign_key: 'team_away_id'
end
