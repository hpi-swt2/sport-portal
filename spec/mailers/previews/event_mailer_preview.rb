# Preview all emails at http://localhost:3000/rails/mailers/event_mailer
class EventMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/event_mailer/event_canceled
  def event_canceled
    EventMailer.event_canceled(User.first, Event.first)
  end
  def event_started
    EventMailer.event_started(User.first, Event.first)
  end
  def event_finished
    EventMailer.event_finished(User.first, Event.first)
  end
end
