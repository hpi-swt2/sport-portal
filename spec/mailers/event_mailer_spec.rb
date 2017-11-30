require "rails_helper"

RSpec.describe EventMailer, type: :mailer do
  describe 'event notification' do
    let(:user) { mock_model User, name: 'Lucas', email: 'lucas@email.com' }
    let(:mail) { described_class.instructions(user).deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq('Instructions')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['noreply@company.com'])
    end

    it 'assigns @name' do
      expect(mail.body.encoded).to match(user.name)
    end

    it 'assigns @confirmation_url' do
      expect(mail.body.encoded)
          .to match("http://aplication_url/#{user.id}/confirmation")
    end
  end
end
