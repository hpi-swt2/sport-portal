namespace :event_notification do
  # This task should only be run once an hour. Otherwise multiple emails for the same event get send.
  def send_event_notification
    events = Event.where(startdate: Time.now + 23.hours..Time.now + 24.hours)
  end
end
