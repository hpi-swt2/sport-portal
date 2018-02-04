require 'rails_helper'

RSpec.describe 'User mailer', type: :mailer do
  let(:user) { FactoryBot.create :user, unconfirmed_email: 'my_new_email@example.com' }

  describe 'confirmation mail' do
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
      confirmation_link = mail_body.find_link(I18n.t('devise.mailer.confirmation_instructions.action'))
      expect(confirmation_link['href']).to include('unneeded_confirmation_token')
    end
  end

  describe 'email changed notification mail' do
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
end
