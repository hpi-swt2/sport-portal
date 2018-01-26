class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'

  private
    def email_with_name(user)
      %('#{user.name}' <#{user.email}>)
    end
end
