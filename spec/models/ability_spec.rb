require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do

  it 'should have admin permissions, if the user is admin' do
    admin = FactoryBot.build(:admin)
    ability = Ability.new(admin)

    ability.should be_able_to(:manage, :all)
  end

  it 'should allow users to manage their own user data' do
    user = FactoryBot.build(:user)
    ability = Ability.new(user)

    ability.should be_able_to(:manage, User, id: user.id)
  end

  it 'should not allow users to crud other users data' do
    user1 = FactoryBot.build(:user)
    user1.save
    other_user = FactoryBot.build(:user)
    other_user.save
    ability = Ability.new(user1)

    ability.should_not be_able_to(:crud, User)
  end
end