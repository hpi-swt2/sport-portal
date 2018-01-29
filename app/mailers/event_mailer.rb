# Sends mails for events: event_canceled, event_started, event_finished
class EventMailer < ApplicationMailer
  def send_mail(user, event, template)
    @user = user
    @event = event

    mail(to: user.email,
         subject: t("event_mailer.#{template}.subject")) do |format|
      format.html { render template }
      format.text { render template }
    end
    prevent_delivery_to_unsubscribed_users(user)
  end
end
