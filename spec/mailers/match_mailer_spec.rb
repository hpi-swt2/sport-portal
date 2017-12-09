require "rails_helper"

RSpec.describe MatchMailer, type: :mailer do
  describe 'match notification' do
    let(:user) { FactoryBot.create(:user) }
    let(:match1) { FactoryBot.create(:match) }
    let(:mail) { MatchMailer.match_notification(user, match1) }
    before(:each) { mail.deliver_now }

    it 'renders the startdate in the subject' do
      expect(mail.subject).to match(I18n.localize(match1.event.startdate))
    end

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
      expect(mail.body.encoded).to match(match1.event.name)
    end

    it 'assigns match team home name' do
      expect(mail.body.encoded).to match(match1.team_home.name)
    end

    it 'assigns match team away name' do
      expect(mail.body.encoded).to match(match1.team_away.name)
    end

    it 'assigns match\'s place' do
      expect(mail.body.encoded).to match(match1.place)
    end

    it 'assigns event\'s startdate' do
      expect(mail.body.encoded).to match(I18n.localize(match1.event.startdate))
    end
  end
end
