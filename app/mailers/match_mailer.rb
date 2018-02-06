#Sends mails for matches: match_notifcation, match_scheduled, match_canceled, match_date_changed
class MatchMailer < ApplicationMailer
  def send_mail(user, match, template)
    @user = user
    @match = match

    team_home = match.team_home
    team_away = match.team_away
    opponent_team = (team_home.has_member? user) ? team_away : team_home
    @opponent_team = opponent_team

    subject = t("match_mailer.#{template}.subject",
                team_name: opponent_team.name,
                event_name: match.event.name)

    mail(to: user.email,
         subject: subject) do |format|
      format.html { render template }
      format.text { render template }
    end

    prevent_delivery_to_event_unsubscribed_users(user)
  end
end
