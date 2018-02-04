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
    show_match ? match_path(participant.match) : team_or_user_path(participant.advancing_participant)
  end

  def team_or_user_path(participant)
    if participant.created_by_event?
      user_path(participant.owners.first)
    else
      team_path(participant)
    end
  end
end
