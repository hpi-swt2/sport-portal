# Preview all emails at http://localhost:3000/rails/mailers/event_mailer
class EventMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/event_mailer/event_canceled
  def event_canceled
    EventMailer.send_mail(User.first, Event.first, :event_canceled)
  end
  def event_started
    EventMailer.send_mail(User.first, Event.first, :event_started)
  end
  def event_finished
    EventMailer.send_mail(User.first, Event.first, :event_finished)
  end
end
