module EventsHelper
  def participant_link(participant)
    participant_path = @event.single? ? user_path(participant) : team_path(participant)
    link_to participant.name, participant_path
  end
end
