class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  private
  def prevent_delivery_to_unsubscribed_users
    if @user && (not @user.has_event_notifications_enabled?)
      mail.perform_deliveries = false
    end
  end
end
