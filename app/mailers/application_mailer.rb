# An ActionMailer sublcass that is used for all email notifications triggered on the platform
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  private
    def email_with_name(user)
      %('#{user.name}' <#{user.email}>)
    end
end
