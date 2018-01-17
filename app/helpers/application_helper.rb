module ApplicationHelper
  def link_to_participant(participant)
    if participant.present?
      link_to participant.name, participant_path(participant)
    else
      '---'
    end
  end

  def participant_path(participant)
    show_match = participant.is_a?(MatchResult) && !participant.knows_advancing_participant
    show_match ? match_path(participant.match) : team_path(participant.advancing_participant)
  end
end
