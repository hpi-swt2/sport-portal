require'rails_helper'

  describe "index event page", type: :feature do
    before(:each) do
      @teamevent = FactoryBot.create :event
      @teamevent.teamsport = true

      @user = FactoryBot.create(:user)

    end

    it "should not be possible to join team event via join button" do
      sign_in @user
      visit events_path

      expect(page).not_to have_button("Join Event")
    end

    it "should not be possible to join team event via join button" do
      sign_in @user
      @singleevent = FactoryBot.create :event
      visit events_path

      expect(page).to have_button("Join Event")
    end

    it "should be possible that label of join button changes to 'Leave Event' when user joins" do
      sign_in @user
      @singleevent = FactoryBot.create :event
      visit events_path
      click_button("Join Event")

      expect(page).to have_button("Leave Event")
    end

    it "should be possible for a user to see, which event he/she joined" do
      sign_in @user
      @singleevent = FactoryBot.create :event
      visit events_path
      click_button("Join Event")

      expect(page).to have_content("Participating")
    end

    it "should be possible to see join button only when deadline has not been passed" do

      sign_in @user
      @singleevent = FactoryBot.create :event
      @singleevent.deadline = Date.yesterday
      visit events_path

      expect(page).not_to have_button("Join Event")
    end

    it "should be not possible to join an event if the user is not logged in" do
      @singleevent = FactoryBot.create :event

      visit events_path()
      expect(page).not_to have_button("Join Event")
    end
  end