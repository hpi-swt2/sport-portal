# An ActionMailer sublcass that is used for all email notifications triggered on the platform
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  #General mailer class
  private
    def prevent_delivery_to_unsubscribed_users
      if @user && (not @user.has_event_notifications_enabled?)
        mail.perform_deliveries = false
      end
    end
end
