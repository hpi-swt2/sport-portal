class EventMailer < ApplicationMailer
  after_action :prevent_delivery_to_unsubscribed_users

  # Sends mails for events: event_canceled, event_started, event_finished
  def send_mail(user, event, template)
    @user = user
    @event = event
    output = render template

    mail(to: @user.email) do |format|
      format.html { output }
      format.text { output }
    end
  end
end
