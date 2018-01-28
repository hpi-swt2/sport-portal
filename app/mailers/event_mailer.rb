class EventMailer < ApplicationMailer
  after_action :prevent_delivery_to_unsubscribed_users

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.match_scheduled.subject
  #
  def event_canceled(user, event)
    @user = user
    @event = event

    mail to: user.email
  end

  def event_started(user, event)
    @user = user
    @event = event

    mail to: user.email
  end

  def event_finished(user, event)
    @user = user
    @event = event

    mail to: user.email
  end

  private
  def prevent_delivery_to_unsubscribed_users
    if @user && (not @user.has_event_notifications_enabled?)
      mail.perform_deliveries = false
    end
  end
end
