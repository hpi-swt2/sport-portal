# An ActionMailer sublcass that is used for all email notifications triggered on the platform
class ApplicationMailer < ActionMailer::Base
  default from: 'sport.portal@gmx.de'
  layout 'mailer'

  #General mailer class
  private
    def prevent_delivery_to_event_unsubscribed_users(user)
      if user && (not user.event_notifications_enabled?)
        mail.perform_deliveries = false
      end
    end
    def prevent_delivery_to_team_unsubscribed_users(user)
      if user && (not user.team_notifications_enabled?)
        mail.perform_deliveries = false
      end
    end
end
