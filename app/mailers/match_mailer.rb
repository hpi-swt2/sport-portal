class MatchMailer < ApplicationMailer
  after_action :prevent_delivery_to_unsubscribed_users

  # Notifies a user about an upcoming match
  def match_notification(user, match)
    @user = user
    @match = match
    I18n.with_locale(I18n.default_locale) do
      mail(to: @user.email,
           subject: I18n.t('match_mailer.match_notification.subject', start_time: I18n.localize(@match.start_time))
      )
    end
  end
  def match_scheduled(user, match)
    @user = user
    @match = match

    mail to: user.email
  end
  def match_canceled(user, match)
    @user = user
    @match = match

    mail to: user.email
  end
  def match_date_changed(user, match)
    @user = user
    @match = match

    mail to: user.email
  end

  private
  def prevent_delivery_to_unsubscribed_users
    if @user && (not @user.has_event_notifications_enabled?)
      mail.perform_deliveries = false
    end
  end
end
