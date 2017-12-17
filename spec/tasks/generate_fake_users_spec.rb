require "rails_helper"

describe 'rake generate_fake_users', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'runs gracefully with no subscribers' do
    expect { task.execute }.not_to raise_error
  end

  it 'should generate 10 fake users' do
    task.execute

    expect { task.execute }.to change { User.count }.from(0).to(10)
  end
end