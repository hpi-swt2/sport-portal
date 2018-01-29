class MatchMailer < ApplicationMailer
  # Notifies a user about an upcoming match
  def match_notification(user, match)
    @user = user
    @match = match
    I18n.with_locale(I18n.default_locale) do
      mail(to: @user.email,
           subject: I18n.t('mailer.match_mailer.match_notification.subject', start_time: I18n.localize(@match.start_time))
      )
    end
  end
end
