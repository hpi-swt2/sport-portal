require "rails_helper"

RSpec.describe EventMailer, type: :mailer do
  describe 'event notification' do
    let(:user) { FactoryBot.create(:user) }
    let(:event) { FactoryBot.create(:event) }
    let(:mail) { EventMailer.event_notification(user, event).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Instructions')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['noreply@company.com'])
    end

    it 'assigns user\'s firstname' do
      expect(mail.body.encoded).to match(user.firstname)
    end

    it 'assigns event\'s name' do
      expect(mail.body.encoded).to match(event.name)
    end

    it 'assigns event\'s participants' do
      expect(mail.body.encoded).to match({})
    end

    it 'assigns event\'s place' do
      expect(mail.body.encoded).to match(event.place)
    end

    it 'assigns @confirmation_url' do
      expect(mail.body.encoded)
          .to match("http://aplication_url/#{user.id}/confirmation")
    end
  end
end
