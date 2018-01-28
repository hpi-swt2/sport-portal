# Preview all emails at http://localhost:3000/rails/mailers/match_mailer
class MatchMailerPreview < ActionMailer::Preview
  def match_notification
    MatchMailer.match_notification(User.first, Match.first)
  end

  # Preview this email at http://localhost:3000/rails/mailers/match_mailer/match_scheduled
  def match_scheduled
    MatchMailer.match_scheduled(User.first, Match.first)
  end

  def match_canceled
    MatchMailer.match_canceled(User.first, Match.first)
  end

  def match_date_changed
    MatchMailer.match_date_changed(User.first, Match.first)
  end
end
