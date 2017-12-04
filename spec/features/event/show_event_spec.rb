require 'rails_helper'

describe "detailled event page", type: :feature do
  before(:each) do
    @user = FactoryBot.create(:user)

    @teamevent = FactoryBot.create(:event, player_type: Event.player_types[:team])
    @singleevent = FactoryBot.create :event, player_type: Event.player_types[:single]
  end

  it "should be possible for a user to join an event with his team, when it is not part of the event yet" do
    sign_in @user
    visit event_path(@teamevent)
    
    expect(page).to have_css(:join_event_button)
  end  

  it "should not be possible for a user to join an event with his team, when it is already participating" do
    @team = FactoryBot.create(:team, :with_five_members)
    @team.owners << @user
    @teamevent.teams << @team
    sign_in @user
    visit event_path(@teamevent)

    expect(page).not_to have_css(:join_event_button)
    expect(page).to have_css(:leave_event_button)
  end

  it "should not be possible to join team event, if its deadline has expired" do
    @oldevent = FactoryBot.create(:event, player_type: Event.player_types[:team], deadline: Date.yesterday)
    sign_in @user
    visit event_path(@oldevent)

    expect(page).not_to have_css(:join_event_button)
  end

  it "should be not possible to join a team event if the user is not logged in" do
     visit event_path(@teamevent)

     expect(page).not_to have_css(:join_event_button)
     expect(page).not_to have_css(:leave_event_button)     
  end

  it "should be possible to join team event via join button" do
    sign_in @user
    visit event_path(@singleevent)

    expect(page).to have_css('a#join_event_button.btn')
  end

  it "should be possible that label of join button changes to 'Leave Event' when user joins" do
    sign_in @user
    visit event_path(@singleevent)
    click_link_or_button(:join_event_button)

    expect(page).to have_css('a#leave_event_button.btn')
  end

  it "should be possible for a user to see, which event he/she joined" do
    sign_in @user
    visit event_path(@singleevent)
    click_link_or_button(:join_event_button)

    expect(page).to have_content("Participating")
  end

  it "should be not possible to join an event if the user is not logged in" do
    visit event_path(@singleevent)
    expect(page).not_to have_css('a#join_event_button.btn')
  end
end
