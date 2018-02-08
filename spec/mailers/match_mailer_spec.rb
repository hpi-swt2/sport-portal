require "rails_helper"

RSpec.describe MatchMailer, type: :mailer do
  describe 'match notification' do
    let(:user) { FactoryBot.create(:user) }
    let(:match1) { FactoryBot.create(:match) }
    let(:mail) { MatchMailer.send_mail(user, match1, :match_notification) }
    before(:each) { mail.deliver_now }

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['sport.portal@gmx.de'])
    end

    it 'assigns user\'s firstname' do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it 'assigns event\'s name' do
      expect(mail.body.encoded).to match(match1.event.name)
    end

    it 'assigns match\'s place' do
      expect(mail.body.encoded).to match(match1.place)
    end

    it 'assigns event\'s startdate' do
      expect(mail.body.encoded).to match(I18n.localize(match1.start_time.to_date))
    end
  end
  describe 'match scheduled' do
    let(:user) { FactoryBot.create(:user) }
    let(:match1) { FactoryBot.create(:match) }
    let(:mail) { MatchMailer.send_mail(user, match1, :match_scheduled) }
    before(:each) { mail.deliver_now }

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['sport.portal@gmx.de'])
    end

    it 'assigns user\'s firstname' do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it 'assigns event\'s name' do
      expect(mail.body.encoded).to match(match1.event.name)
    end
  end
  describe 'match date changed' do
    let(:user) { FactoryBot.create(:user) }
    let(:match1) { FactoryBot.create(:match) }
    let(:mail) { MatchMailer.send_mail(user, match1, :match_date_changed) }
    before(:each) { mail.deliver_now }

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['sport.portal@gmx.de'])
    end

    it 'assigns user\'s firstname' do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it 'assigns event\'s name' do
      expect(mail.body.encoded).to match(match1.event.name)
    end

    it 'assigns event\'s startdate' do
      expect(mail.body.encoded).to match(I18n.localize(match1.start_time.to_date))
    end
  end
  describe 'match canceled' do
    let(:user) { FactoryBot.create(:user) }
    let(:match1) { FactoryBot.create(:match) }
    let(:mail) { MatchMailer.send_mail(user, match1, :match_canceled) }
    before(:each) { mail.deliver_now }

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['sport.portal@gmx.de'])
    end

    it 'assigns user\'s firstname' do
      expect(mail.body.encoded).to match(user.first_name)
    end

    it 'assigns event\'s name' do
      expect(mail.body.encoded).to match(match1.event.name)
    end
  end

  it 'should not send mails to users with disabled event notification settings' do
    match = FactoryBot.create(:match)
    user = FactoryBot.create(:user)
    user.event_notifications_enabled = false
    mail = MatchMailer.send_mail(user, match, :match_canceled)
    expect { mail.deliver_now }.to_not change { ActionMailer::Base.deliveries.length }
  end

  it 'should assign opponent team to team_away when user is member of team_home' do
    user = FactoryBot.create(:user)
    match = FactoryBot.create(:match)
    match.team_home = user.create_team_for_event
    mail = MatchMailer.send_mail(user, match, :match_canceled)
    mail.deliver_now

    expect(mail.body.encoded).to match(match.team_away.name)
  end

  it 'should assign opponent team to team_home when user is member of team_away' do
    user = FactoryBot.create(:user)
    match = FactoryBot.create(:match)
    match.team_away = user.create_team_for_event
    mail = MatchMailer.send_mail(user, match, :match_canceled)
    mail.deliver_now

    expect(mail.body.encoded).to match(match.team_home.name)
  end

  it 'should assign opponent team to team_home when user is no member of both participating teams' do
    user = FactoryBot.create(:user)
    match = FactoryBot.create(:match)
    mail = MatchMailer.send_mail(user, match, :match_canceled)
    mail.deliver_now

    expect(mail.body.encoded).to match(match.team_home.name)
  end
end
