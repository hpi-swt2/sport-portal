module MatchesHelper
  def participant_link(participant)
    if participant.present?
      path = participant.is_a?(MatchResult) ? match_path(participant.match) : team_path(participant)
      link_to participant.name, path
    else
      '---'
    end
  end
end
