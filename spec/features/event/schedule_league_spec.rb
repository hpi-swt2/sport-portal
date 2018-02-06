require 'rails_helper'

describe "schedule page", type: :feature do

  before(:each) do
    @league = FactoryBot.create :league, :single_player
    @user = FactoryBot.create :user
    @another_user = FactoryBot.create :user
    @league.startdate = Date.yesterday
    @league.add_participant(@user)
    @league.add_participant(@another_user)
  end

  it 'has link to player' do
    visit event_schedule_path(@league)

    click_on(@user.name)
    expect(page).to have_current_path(user_path(@user))
  end
end
