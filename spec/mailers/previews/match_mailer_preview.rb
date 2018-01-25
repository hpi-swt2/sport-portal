# Preview all emails at http://localhost:3000/rails/mailers/match_mailer
class MatchMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/match_mailer/match_scheduled
  def match_scheduled
    MatchMailerMailer.match_scheduled
  end

  def match_canceled
    MatchMailerMailer.match_canceled
  end

  def match_date_changed
    MatchMailerMailer.match_date_changed
  end

end
