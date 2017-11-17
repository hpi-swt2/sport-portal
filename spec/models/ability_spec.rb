require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do

  before(:context) do
    @user =  FactoryBot.create(:user)
    @other_user =  FactoryBot.create(:user)
    @admin = FactoryBot.create(:admin)
  end

  after(:context) do
    @user.destroy
    @other_user.destroy
    @admin.destroy
  end

  it 'should have admin permissions, if the user is admin' do
    ability = Ability.new(@admin)

    ability.should be_able_to(:manage, :all)
  end

  it 'should allow users to manage their own user data' do
    ability = Ability.new(@user)

    ability.should be_able_to(:manage, @user)
  end

  it 'should not allow users to crud other users data' do
    ability = Ability.new(@user)

    ability.should_not be_able_to(:manage, @other_user)
  end

  it 'should allow users to crud events they created' do
    event = Event.new(creator: @user)

    ability = Ability.new(@user)
    ability.should be_able_to(:manage, event)
  end

  it 'should not allow users to crud events they did not create' do
    event = Event.new

    ability = Ability.new(@user)
    ability.should_not be_able_to(:manage, event)
  end

  it 'should allow admin to crud teams they created' do
    team = Team.new(creator: @user)

    ability = Ability.new(@user)
    ability.should be_able_to(:manage, team)
  end

  it 'should not allow users to crud teams they did not create' do
    team = Team.new

    ability = Ability.new(@user)
    ability.should_not be_able_to(:manage, team)
  end
end