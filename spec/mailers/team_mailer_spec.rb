require 'rails_helper'

RSpec.describe TeamMailer, type: :mailer do
  describe 'User added to team' do
    let(:user) { FactoryBot.create(:user) }
    let(:team) { FactoryBot.create(:team) }
    let(:mail) { TeamMailer.user_added_to_team(user, team) }
    before(:each) { mail.deliver_now }

    it 'renders the team name in the subject' do
      expect(mail.subject).to eq(I18n.t('mailer.team_mailer.user_added_to_team.subject',
                                        team_name: team.name))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'assigns the user\'s firstname' do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it 'assigns the team\'s name' do
      expect(mail.body.encoded).to match(team.name)
    end
  end

  describe 'Team registered to event' do
    let(:user) { FactoryBot.create(:user) }
    let(:team) { FactoryBot.create(:team) }
    let(:event) { FactoryBot.create(:event) }
    let(:mail) { TeamMailer.team_registered_to_event(user, team, event) }
    before(:each) { mail.deliver_now }

    it 'renders the team name and event name in the subject' do
      expect(mail.subject).to eq(I18n.t('mailer.team_mailer.team_registered_to_event.subject',
                                        team_name: team.name,
                                        event_name: event.name))
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'assigns the user\'s firstname' do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it 'assigns the team\'s name' do
      expect(mail.body.encoded).to match(team.name)
    end

    it 'assigns the event\'s name' do
      expect(mail.body.encoded).to match(event.name)
    end

    it 'renders the event link' do
      url = event_url(event)
      expect(mail.body.encoded).to match(url)
    end
  end

  describe 'users\'s notification settings' do
    let(:user) { FactoryBot.create(:user) }
    let(:team) { FactoryBot.create(:team) }

    it 'should send mails to users with enabled team notification settings' do
      allow(user).to receive(:has_team_notifications_enabled?).and_return(true)
      mail = TeamMailer.user_added_to_team(user, team)
      mail.deliver_now

      expect(ActionMailer::Base.deliveries).to have(1).items
    end

    it 'should not send mails to users with disabled team notification settings' do
      allow(user).to receive(:has_team_notifications_enabled?).and_return(false)
      mail = TeamMailer.user_added_to_team(user, team)
      mail.deliver_now

      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end
end
