require "rails_helper"

describe 'rake match_notification:send_match_notification', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'runs gracefully with no subscribers' do
    expect { task.execute }.not_to raise_error
  end

  context 'exists a match in next 24 hours' do
    let(:participants) { [FactoryBot.create(:user)] }
    let(:event) { FactoryBot.create(:event, startdate: Date.tomorrow, participants: participants) }
    let(:match) { FactoryBot.create(:match, event: event) }

    it 'should send a match notification to all participants' do
      email_count = event.participants.count
      print Match.joins(:event).where(events: { startdate: Date.tomorrow.all_day })
      expect { task.execute }.to change { ActionMailer::Base.deliveries.length }.from(0).to(email_count)
    end
  end

  context 'exists no match in next 24 hours' do
    let(:event) { FactoryBot.create(:event, startdate: Date.tomorrow + 1.day) }
    let(:match) { FactoryBot.create(:match, event: event) }

    it 'should not send a match notification' do
      task.execute

      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end
end