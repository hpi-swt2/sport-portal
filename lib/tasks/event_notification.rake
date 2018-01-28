namespace :event_notification do
  desc 'Notify users of teams whose events start that day.'
  task send_event_start_notification: :environment do
    events = Event.where(startdate: Date.today.all_day)
    events.find_each(batch_size: 10) do |event|
      event.teams.find_each(batch_size: 10) do |team|
        team.members.each do |participant|
          EventMailer.event_started(participant, event).deliver_now
        end
      end
    end
  end
  desc 'Notify users of teams whose events end that day.'
  task send_event_end_notification: :environment do
    events = Event.where(enddate: Date.today.all_day)
    events.find_each(batch_size: 10) do |event|
      event.teams.find_each(batch_size: 10) do |team|
        team.members.each do |participant|
          EventMailer.event_finished(participant, event).deliver_now
        end
      end
    end
  end
end