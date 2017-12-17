require "rails_helper"

describe 'rake generate_fake_users', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end
  it 'runs gracefully with no subscribers' do
    expect { task.execute }.not_to raise_error
  end

  context 'Less than 10 users' do
    it 'should generate 10 fake users' do
      expect { task.execute }.to change { User.count }.from(0).to(10)
    end
  end

  context '10 or more users' do
    before(:each) do
      10.times { FactoryBot.create(:user) }
    end

    it 'should not generate new users' do
      expect { task.execute }.not_to change { User.count }
    end
  end
end