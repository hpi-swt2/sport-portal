class Event < ApplicationRecord
    enum player_types: [:single, :team]

    def self.types
      %w(Tournament League)
    end

    validates :name, :discipline, :game_mode, presence: true
end
