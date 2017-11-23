require'rails_helper'

describe "detailled event page", type: :feature do
  before(:each) do
    @user = FactoryBot.create(:user, password: '123456', password_confirmation: '123456')
    visit new_user_session_path
    within('form', id: 'new_user') do
      fill_in "user[email]", :with => @user[:email]
      fill_in "user[password]", :with => '123456'
      find('input[type="submit"]').click
    end

    @teamevent = FactoryBot.create :event
    @teamevent.teamsport = true
    @singleevent = FactoryBot.create :event
  end

  it "should not be possible to join team event via join button" do
    visit events_path(@teamevent)

    expect(page).not_to have_button("Join Event")
  end

  it "should not be possible to join team event via join button" do

    visit events_path(@singleevent)

    expect(page).to have_button("Join Event")
  end

  it "should be possible that label of join button changes to 'Leave Event' when user joins" do
    visit events_path(@singleevent)
    click_button("Join Event")

    expect(page).to have_button("Leave Event")
  end

  it "should be possible for a user to see, which event he/she joined" do
    visit events_path(@singleevent)
    click_button("Join Event")

    expect(page).to have_content("Participating")
  end

  it "should be not possible to join an event if the user is not logged in" do
    @user = FactoryBot.create :user
    visit events_path(@singleevent)
    expect(page).not_to have_button("Join Event")
  end

end