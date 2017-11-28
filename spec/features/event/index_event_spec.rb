require'rails_helper'

  describe "index event page", type: :feature do
    before(:each) do
      @teamevent = FactoryBot.create(:event, player_type: Event.player_types[:team])
      @user = FactoryBot.create(:user)
    end

    it "should not display a join button for teamevents" do
      sign_in @user
      visit events_path

      expect(page).not_to have_css('a#joinbutton.btn')
    end

    it "should display a button for single player events" do
      sign_in @user
      @singleevent = FactoryBot.create :event, player_type: Event.player_types[:single]
      visit events_path

      expect(page).to have_css('a#joinbutton.btn')
    end

    it "should be possible that label of join button changes to 'Leave Event' when user joins" do
      sign_in @user
      @singleevent = FactoryBot.create :event, player_type: Event.player_types[:single]
      visit events_path
      click_link("Join Event")

      expect(page).to have_css('a#leavebutton.btn')
    end

    it "should be possible for a user to see, which event he/she joined" do
      sign_in @user
      @singleevent = FactoryBot.create :event, player_type: Event.player_types[:single]
      visit events_path
      click_link_or_button("Join Event")

      expect(page).to have_content("Participating")
    end

    it "should be possible to see join button only when deadline has not been passed" do

      sign_in @user
      @singleevent = FactoryBot.create :event, player_type: Event.player_types[:single]
      @singleevent.deadline = Date.yesterday
      visit events_path

      expect(page).not_to have_button("Join Event")
    end

    it "should be not possible to join an event if the user is not logged in" do
      @singleevent = FactoryBot.create :event, player_type: Event.player_types[:single]

      visit events_path()
      expect(page).not_to have_button("Join Event")
    end
  end