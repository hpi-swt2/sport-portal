require "rails_helper"

describe 'rake event_notification:send_event_start_notification', type: :task do
  let(:participants) { [FactoryBot.create(:user)] }

  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'runs gracefully with no subscribers' do
    expect { task.execute }.not_to raise_error
  end

  context 'exists an event that starts today' do
    let(:event) { FactoryBot.create(:event, :with_teams) }

    it 'should send an event start notification to all participants' do
      event.startdate = Date.today
      event.save
      email_count = event.teams.map(&:members).flatten(1).count
      expect { task.execute }.to change { ActionMailer::Base.deliveries.length }.by(email_count)
    end
  end

  context 'exists no event that starts today' do
    let(:event) { FactoryBot.create(:event, :with_teams) }

    it 'should send no event start notification to all participants' do
      event.startdate = Date.tomorrow
      event.save
      expect { task.execute }.to change { ActionMailer::Base.deliveries.length }.by(0)
    end
  end
end

describe 'rake event_notification:send_event_end_notification', type: :task do
    let(:participants) { [FactoryBot.create(:user)] }

    it 'preloads the Rails environment' do
      expect(task.prerequisites).to include 'environment'
    end

    it 'runs gracefully with no subscribers' do
      expect { task.execute }.not_to raise_error
    end

    context 'exists an event that ends today' do
      let(:event) { FactoryBot.create(:event, :with_teams) }

      it 'should send an event end notification to all participants' do
        event.enddate = Date.today
        event.save
        email_count = event.teams.map(&:members).flatten(1).count
        expect { task.execute }.to change { ActionMailer::Base.deliveries.length }.by(email_count)
      end
    end

    context 'exists no event that starts today' do
      let(:event) { FactoryBot.create(:event, :with_teams) }

      it 'should send no event end notification to all participants' do
        event.enddate = Date.tomorrow
        event.save
        expect { task.execute }.to change { ActionMailer::Base.deliveries.length }.by(0)
      end
    end
  end
