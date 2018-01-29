# An ApplicationMailer subclass that is responsible for informing users about team-related changes via email
class TeamMailer < ApplicationMailer
  # Notifies a user that he/she was added to a team
  def user_added_to_team(user, team)
    @user = user
    @team = team
    mail to: @user.email_with_name,
         subject: t('team_mailer.user_added_to_team.subject',
                    team_name: @team.name)
    prevent_delivery_to_team_unsubscribed_users(user)
  end

  # Notifies members of a team that their team was registered to an event
  def team_registered_to_event(user, team, event)
    @user = user
    @team = team
    @event = event
    mail to: @user.email_with_name,
         subject: t('team_mailer.team_registered_to_event.subject',
                    team_name: @team.name,
                    event_name: @event.name)
    prevent_delivery_to_team_unsubscribed_users(user)
  end

end
