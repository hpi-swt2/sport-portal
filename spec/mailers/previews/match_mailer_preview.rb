# Preview all emails at http://localhost:3000/rails/mailers/match_mailer
class MatchMailerPreview < ActionMailer::Preview
  def match_notification
    MatchMailer.send_mail(User.first, Match.first, :match_notification)
  end

  # Preview this email at http://localhost:3000/rails/mailers/match_mailer/match_scheduled
  def match_scheduled
    MatchMailer.send_mail(User.first, Match.first, :match_scheduled)
  end

  def match_canceled
    MatchMailer.send_mail(User.first, Match.first, :match_canceled)
  end

  def match_date_changed
    MatchMailer.send_mail(User.first, Match.first, :match_date_changed)
  end
end
