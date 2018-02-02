require 'rails_helper'

RSpec.describe Devise.mailer, type: :mailer do


  describe 'confirmation mail' do
    let(:user) { FactoryBot.create :user, unconfirmed_email: 'my_new_email@example.com' }
    let(:mail) { Devise.mailer.confirmation_instructions(user, 'unneeded_confirmation_token',
                                                         to: user.unconfirmed_email) } # see devise>confirmable
    before(:each) { mail.deliver_now }

    it 'renders the correct subject' do
      expect(mail.subject).to eq(I18n.t('devise.mailer.confirmation_instructions.subject'))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.unconfirmed_email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['sport.portal@gmx.de'])
    end

    it 'assigns the user\'s firstname' do
      expect(mail.body.encoded).to match(user.first_name.capitalize)
    end

    it 'has a confirmation link' do
      mail_body = Capybara.string(mail.body.encoded)
      expect(mail_body).to have_link(I18n.t('devise.mailer.confirmation_instructions.action'))
    end

  end

  describe 'email changed notification mail' do
    let(:user) { FactoryBot.create :user, unconfirmed_email: 'my_new_email@example.com' }
    let(:mail) { Devise.mailer.email_changed(user) }
    before(:each) { mail.deliver_now }

    it 'renders the correct subject' do
      expect(mail.subject).to eq(I18n.t('devise.mailer.email_changed.subject'))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['sport.portal@gmx.de'])
    end

    it 'assigns the user\'s firstname' do
      expect(mail.body.encoded).to match(user.first_name.capitalize)
    end

    it 'displays the important information' do
      mail_body = Capybara.string(mail.body.encoded)
      expect(mail_body).to have_text(I18n.t('devise.mailer.email_changed.body',
                                                   oldmail: user.email, newmail: user.unconfirmed_email))
    end
  end

  describe 'New Users' do
    it 'should receive a confirmation mail on sign-up' do
      ActionMailer::Base.deliveries.clear
      user = FactoryBot.build(:user)
      user.save!
      Mail::Message
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
  end
end
