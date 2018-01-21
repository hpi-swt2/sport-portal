class EventMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.match_scheduled.subject
  #
  def match_scheduled(user, match)
    @user_name = user.name
    @opponent = match.team_home
    @event = match.event
    @date = match.gameday
    @event_url = events_url(match.event)

    mail to: user.email
  end
end
