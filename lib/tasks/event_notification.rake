namespace :event_notification do
  desc 'Sends emails to all event participants 24 hours in advance.
        This task should only be run once an hour. Otherwise multiple emails for the same event are send.'
  task send_event_notification: :environment do
    events = Event.where(startdate: Time.now + 23.hours..Time.now + 24.hours)
    events.each do |event|
      members = event.joins(:teams).joins(:members).distinct
      members.each { |m| EventMailer.deliver_event_notification(m, event) }
    end
  end
end
