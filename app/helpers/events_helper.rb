module EventsHelper
  def link_to_participant(participant)
    participant_path = @event.single? ? user_path(participant) : team_path(participant)
    link_to participant.name, participant_path
  end
end
