class Event < ApplicationRecord
  #Represents a sports event, to be subclassed by league or tournament
  
  enum player_types: [:single, :team]

  def self.types
    %w(Tournament League)
  end

  validates :name, :discipline, :game_mode, presence: true
end
