# == Schema Information
#
# Table name: events
#
#  name                         :string
#  description                  :text
#  discipline                   :string
#  player_type                  :integer
#  max_teams                    :integer
#  game_mode                    :integer         not null
#  type                         :integer
#  created_at                   :datetime        not null
#  updated_at                   :datetime        not null
#  index_events_on_game_mode    :index ["game_mode"]
#  index_events_on_player_type  :index ["player_type"]
#

class Event < ApplicationRecord
  enum player_types: [:single, :team]

  def self.types
    %w(Tournament League)
  end

  validates :name, :discipline, :game_mode, presence: true
end
