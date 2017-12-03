class EventMailer < ApplicationMailer
  # Notifies a user about an upcoming match
  def event_notification(user, event)
      @user = user
      @event = event
      locale = Rails.application.config.default_locale
      I18n.with_locale(locale) do
        mail(to: @user.email,
             subject: I18n.t('event_mailer.event_notification.subject', startdata: @match.event.startdate)
        )
      end
  end
end
