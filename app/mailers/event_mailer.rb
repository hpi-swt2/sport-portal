class EventMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.match_scheduled.subject
  #
  def event_canceled(user, event)
    @user_name = user.name
    @event = event.name
    @event_url = "wow"
    #events_url(event)

    mail to: user.email
  end

  def event_started(user, event)
    @user_name = user.name
    @event = event.name
    @event_url = "wow"
    #events_url(event)

    mail to: user.email
  end

  def event_finished(user, event)
    @user_name = user.name
    @event = event.name
    @event_url = "wow"
    #events_url(event)

    mail to: user.email
  end

end
