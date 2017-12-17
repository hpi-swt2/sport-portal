module MatchesHelper
  def participant_link(participant, participant_type)
    if participant
      participant_name = participant.name
      if participant_type == 'Match'
        link_name = I18n.t 'matches.winner_of_match', match: participant_name
        link_to link_name, match_path(participant)
      else
        link_to participant_name, team_path(participant)
      end
    else
      '---'
    end
  end
end
