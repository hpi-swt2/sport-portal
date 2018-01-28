# An ActionMailer sublcass that is used for all email notifications triggered on the platform
class ApplicationMailer < ActionMailer::Base
  include ApplicationMailerHelper
  default from: 'from@example.com'
  layout 'mailer'
end
