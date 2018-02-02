require 'rails_helper'

RSpec.describe DeviseMailer, type: :mailer do
  describe 'confirmation mails' do
    it 'should receive a confirmation mail on sign-up' do
      ActionMailer::Base.deliveries.clear
      user = FactoryBot.build(:user)
      user.save!
      expect(ActionMailer::Base.deliveries.length).to eq(1)
      confirmation_mail = ActionMailer::Base.deliveries.first
      confirmation_mail_body = Capybara.string(confirmation_mail.body.encoded)
      expect(confirmation_mail.to.length).to eq(1) #one receiver
      expect(confirmation_mail.to.first).to eq(user.email) #that is our user
      expect(confirmation_mail.subject).to eq(I18n.t('devise.mailer.confirmation_instructions.subject'))
      expect(confirmation_mail_body).to have_link(I18n.t('devise.mailer.confirmation_instructions.action'))
    end

    it 'should receive no confirmation mail when signing up via omniauth' do
      ActionMailer::Base.deliveries.clear
      user = FactoryBot.build :user, :with_openid
      user.save!
      expect(ActionMailer::Base.deliveries.length).to eq(0)
    end

    it 'should receive a confirmation and a notification mail on email change' do
      user = FactoryBot.build :user
      sign_in user
      ActionMailer::Base.deliveries.clear

      old_mail = user.email
      new_mail = 'my_new_mail@example.com'
      new_attributes = { email: new_mail,
                         current_password: user.password }
      put :update, params: { id: user.to_param, user: new_attributes }

      # notification mail to the old address
      expect(ActionMailer::Base.deliveries.length).to eq(2)
      notification_mail = ActionMailer::Base.deliveries.first
      notification_mail_body = Capybara.string(notification_mail.body.encoded)
      expect(notification_mail.to.length).to eq(1) #one receiver
      expect(notification_mail.to.first).to eq(old_mail) #that is our users old mail address
      expect(notification_mail.subject).to eq(I18n.t('devise.mailer.email_changed.subject'))
      expect(notification_mail_body).to have_text(I18n.t('devise.mailer.email_changed.body', oldmail: old_mail, newmail: new_mail))

      # confirmation email to the new address
      confirmation_mail = ActionMailer::Base.deliveries.second
      confirmation_mail_body = Capybara.string(confirmation_mail.body.encoded)
      expect(confirmation_mail.to.length).to eq(1) #one receiver
      expect(confirmation_mail.to.first).to eq(new_mail) #that is our users new mail address
      expect(confirmation_mail.subject).to eq(I18n.t('devise.mailer.confirmation_instructions.subject'))
      expect(confirmation_mail_body).to have_link(I18n.t('devise.mailer.confirmation_instructions.action'))
    end
  end
end
