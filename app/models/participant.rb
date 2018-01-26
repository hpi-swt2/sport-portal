class Participant < ApplicationRecord
  belongs_to :team
  belongs_to :event

  def number_of_wins
    wins = 0
    event = Event.find(event_id)
    event.matches.each do |match|
      if match.has_winner?
        if match.winner.id == team_id
          wins = 1
        end
      end
    end
    wins
  end

  def number_of_losses
    losses = 0
    event = Event.find(event_id)
    event.matches.each do |match|
      if match.has_winner?
        if match.loser.id == team_id && (team_id == match.team_away_id || team_id == match.team_home_id)
          losses = 1
        end
      end
    end
    losses
  end

  def number_of_draws
    draws = 0
    event = Event.find(event_id)
    event.matches.each do |match|
      if (not match.has_winner?) && (team_id == match.team_away_id || team_id == match.team_home_id)
        draws = 1
      end
    end
    draws
  end
end
