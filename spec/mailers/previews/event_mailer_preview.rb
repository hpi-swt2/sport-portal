# Preview all emails at http://localhost:3000/rails/mailers/event_mailer
class EventMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/event_mailer/match_scheduled
  def match_scheduled
    EventMailerMailer.match_scheduled
  end

end
