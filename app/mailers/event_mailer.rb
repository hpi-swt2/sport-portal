class EventMailer < ApplicationMailer
  # Notifies a user about an upcoming match
  def event_notification(user, event, participants)
    @user = user
    @event = event
    @participants = participants
    locale = I18n.default_locale
    I18n.with_locale(locale) do
      mail(to: @user.email,
           subject: I18n.t('event_mailer.event_notification.subject', startdate: @event.startdate)
      )
    end
  end
end
