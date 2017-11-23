require'rails_helper'

describe "detailled event page", type: :feature do
  before(:each) do
    @user = FactoryBot.create(:user)

    @teamevent = FactoryBot.create :event
    @teamevent.teamsport = true
    @singleevent = FactoryBot.create :event
  end

  it "should not be possible to join team event via join button" do
    sign_in @user
    visit events_path(@teamevent)
    expect(page).not_to have_button("Join Event")
  end

  it "should not be possible to join team event via join button" do
    sign_in @user
    visit events_path(@singleevent)

    expect(page).to have_button("Join Event")
  end

  it "should be possible that label of join button changes to 'Leave Event' when user joins" do
    sign_in @user
    visit events_path(@singleevent)
    click_button("Join Event")

    expect(page).to have_button("Leave Event")
  end

  it "should be possible for a user to see, which event he/she joined" do
    sign_in @user
    visit events_path(@singleevent)
    click_button("Join Event")

    expect(page).to have_content("Participating")
  end

  it "should be not possible to join an event if the user is not logged in" do
    visit events_path(@singleevent)
    expect(page).not_to have_button("Join Event")
  end

end