# Preview all emails at http://localhost:3000/rails/mailers/team_mailer
class TeamMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/team_mailer/user_added_to_team
  def user_added_to_team
    TeamMailer.user_added_to_team(User.first, Team.first)
  end

  # Preview this email at http://localhost:3000/rails/mailers/team_mailer/team_registered_to_event
  def team_registered_to_event
    TeamMailer.team_registered_to_event(User.first, Team.first, Event.first)
  end
end
