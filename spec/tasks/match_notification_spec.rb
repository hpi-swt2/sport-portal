require "rails_helper"

describe 'rake match_notification:send_match_notification', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'runs gracefully with no subscribers' do
    expect { task.execute }.not_to raise_error
  end

  context 'exists match in next 24 hours' do
    let(:match) { FactoryBot.create(:match) }

    it 'should send a match notification to all partipants' do
      task.execute
    end
  end

  context 'exists no match in next 24 hours' do
    let(:match) { FactoryBot.create(:match) }

    it 'should not send a match notification' do
      task.execute
    end
  end
end