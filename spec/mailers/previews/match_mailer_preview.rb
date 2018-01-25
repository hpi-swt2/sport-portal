# Preview all emails at http://localhost:3000/rails/mailers/match_mailer
class MatchMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/match_mailer/match_scheduled
  def match_scheduled
    fake
    @mail = MatchMailer.match_scheduled(@user, @match)
    delete_fakes
    return @mail
  end

  def match_canceled
    fake
    @mail = MatchMailer.match_canceled(@user, @match)
    delete_fakes
    return @mail
  end

  def match_date_changed
    fake
    @mail = MatchMailer.match_date_changed(@user, @match)
    delete_fakes
    return @mail
  end
  private
    def fake
      @user = FactoryBot.create(:user)
      @match = FactoryBot.build(:match)
    end

    def delete_fakes
      @user.destroy
      @match.destroy
    end

end
