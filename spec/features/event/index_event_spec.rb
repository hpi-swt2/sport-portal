require 'rails_helper'

describe "index event page", type: :feature do
  before(:each) do
    @user = FactoryBot.create(:user)
  end

  context "for all events" do
    before(:each) do
      @singleevent = FactoryBot.create :event, player_type: Event.player_types[:single]
      @teamevent = FactoryBot.create(:event, player_type: Event.player_types[:team])
    end

    it "should change the join button to a leave button after the user joins" do
      sign_in @user
      visit events_path
      click_link(:join_event_button)
      expect(page).not_to have_link(:join_event_button)
      expect(page).to have_link(:leave_event_button)
    end

    # it "should change the leave button to a join button after the user leaves" do
    #   sign_in @user
    #   visit events_path
    #   click_link(:leave_event_button)
    #   expect(page).not_to have_link(:leave_event_button)
    #   expect(page).to have_link(:join_event_button)
    # end

    it "should show the user whether they joined" do
      sign_in @user
      visit events_path
      click_link_or_button(:join_event_button)
      expect(page).to have_content("Participating")
    end

    it "should not allow the user to join if they are not logged in" do
      visit events_path
      expect(page).not_to have_button(:join_event_button)
    end
  end

  context "for single player events" do
    before(:each) do
      @singleevent = FactoryBot.create :event, player_type: Event.player_types[:single]
    end

    it "should have a join button" do
      sign_in @user
      visit events_path
      expect(page).to have_link(:join_event_button)
    end
  end

  context "for team events" do
    before(:each) do
      @teamevent = FactoryBot.create(:event, player_type: Event.player_types[:team])
    end

    it "should not display a join button" do
      sign_in @user
      visit events_path
      expect(page).not_to have_link(:join_event_button)
    end
  end

  context "for events whose deadline has passed" do
    before(:each) do
      @oldevent = FactoryBot.create :event, deadline: Date.yesterday
    end

    it "should show them if the corresponding checkbox is enabled" do
      visit "/events?showAll=on"
      expect(page).to have_content(@oldevent.deadline.to_s)
    end

    it "should hide them if the corresponding checkbox is disabled" do
      visit events_path
      expect(page).not_to have_content(@oldevent.deadline.to_s)
    end

    it "should not display a join button" do
      sign_in @user
      visit "/events?showAll=on"
      expect(page).not_to have_button(:join_event_button)
    end
  end
end
