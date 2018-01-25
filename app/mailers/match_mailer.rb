class MatchMailer < ApplicationMailer
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
    @user_name = user.name
    @opponent = match.team_home
    @event = match.event
    @date = match.gameday
    @event_url = events_url(match.event)

    mail to: user.email
  end
  def match_canceled(user, match)
    @user_name = user.name
    @opponent = match.team_home
    @event = match.event
    @event_url = events_url(match.event)

    mail to: user.email
  end
  def match_date_changed(user, match)
    @user_name = user.name
    @opponent = match.team_home
    @event = match.event
    @date = match.gameday
    @event_url = events_url(match.event)

    mail to: user.email
  end
end
