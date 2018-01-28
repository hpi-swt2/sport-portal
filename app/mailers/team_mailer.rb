# An ApplicationMailer subclass that is responsible for informing users about team-related changes via email
class TeamMailer < ApplicationMailer
  after_action :prevent_delivery_to_unsubscribed_users

  # Notifies a user that he/she was added to a team
  def user_added_to_team(user, team)
    @user = user
    @team = team
    mail to: @user.email_with_name,
         subject: t('mailer.team_mailer.user_added_to_team.subject',
                    team_name: @team.name)
  end

  # Notifies members of a team that their team was registered to an event
  def team_registered_to_event(user, team, event)
    @user = user
    @team = team
    @event = event
    mail to: @user.email_with_name,
         subject: t('mailer.team_mailer.team_registered_to_event.subject',
                    team_name: @team.name,
                    event_name: @event.name)
  end

  private
    def prevent_delivery_to_unsubscribed_users
      if @user && (not @user.has_team_notifications_enabled?)
        mail.perform_deliveries = false
      end
    end
end
