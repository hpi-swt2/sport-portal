class EventMailer < ApplicationMailer

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

end
