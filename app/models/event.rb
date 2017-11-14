class Event < ApplicationRecord
    enum player_types: [:single, :team]
end
