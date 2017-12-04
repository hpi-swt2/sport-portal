# == Schema Information
#
# Table name: matches
#
#  id           :integer          not null, primary key
#  place        :string
#  score_home   :integer
#  score_away   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  team_home_id :integer
#  team_away_id :integer
#  event_id     :integer
#  points_home  :integer
#  points_away  :integer
#  gameday      :integer
#

class Match < ApplicationRecord
  belongs_to :team_home, class_name: 'Team', foreign_key: 'team_home_id'
  belongs_to :team_away, class_name: 'Team', foreign_key: 'team_away_id'
  belongs_to :event, dependent: :delete
end
