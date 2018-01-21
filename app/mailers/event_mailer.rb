class EventMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_mailer.match_scheduled.subject
  #
  def match_scheduled
    @greeting = "Hi"

    mail to: "to@example.org"
  end
end
