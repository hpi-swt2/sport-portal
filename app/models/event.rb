class Event < ApplicationRecord
    enum player_types: [:single, :team]
    validates :name, :discipline, :game_mode, presence: true
end
