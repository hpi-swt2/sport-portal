require "rails_helper"

RSpec.describe EventMailer, type: :mailer do
  describe "event_canceled" do
    let(:user) { FactoryBot.create(:user) }
    let(:event1) { FactoryBot.create(:event) }
    let(:mail) { EventMailer.event_canceled(user, event1) }
    before(:each) { mail.deliver_now }

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'assigns user\'s firstname' do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it 'assigns event\'s name' do
      expect(mail.body.encoded).to match(event1.name)
    end
  end
  describe "event_started" do
    let(:user) { FactoryBot.create(:user) }
    let(:event1) { FactoryBot.create(:event) }
    let(:mail) { EventMailer.event_started(user, event1) }
    before(:each) { mail.deliver_now }

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'assigns user\'s firstname' do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it 'assigns event\'s name' do
      expect(mail.body.encoded).to match(event1.name)
    end
  end
  describe "event_finished" do
    let(:user) { FactoryBot.create(:user) }
    let(:event1) { FactoryBot.create(:event) }
    let(:mail) { EventMailer.event_finished(user, event1) }
    before(:each) { mail.deliver_now }

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'assigns user\'s firstname' do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it 'assigns event\'s name' do
      expect(mail.body.encoded).to match(event1.name)
    end
  end

end
