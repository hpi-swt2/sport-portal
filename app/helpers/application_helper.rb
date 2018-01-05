module ApplicationHelper
  def link_to_participant(participant)
    if participant.present?
      show_match = participant.is_a?(MatchResult) && !participant.knows_advancing_participant
      path = show_match ? match_path(participant.match) : team_path(participant.advancing_participant)
      link_to participant.name, path
    else
      '---'
    end
  end
end
