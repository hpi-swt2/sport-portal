# Preview all emails at http://localhost:3000/rails/mailers/match_mailer
class MatchMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/match_mailer/match_scheduled
  def match_scheduled
    fake
    MatchMailer.match_scheduled(@user, @match)
  end

  def match_canceled
    MatchMailer.match_canceled
  end

  def match_date_changed
    MatchMailer.match_date_changed
  end

  private
    def fake
      @user = FactoryBot.create(:user)
      @match = FactoryBot.build(:match)
    end

end
