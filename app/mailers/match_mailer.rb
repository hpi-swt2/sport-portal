#Sends mails for matches: match_notifcation, match_scheduled, match_canceled, match_date_changed
class MatchMailer < ApplicationMailer
  def send_mail(user, match, template)
    @user = user
    @match = match

    mail(to: user.email,
         subject: t("match_mailer.#{template}.subject")) do |format|
      format.html { render template }
      format.text { render template }
    end
    prevent_delivery_to_unsubscribed_users(user)
  end
end
