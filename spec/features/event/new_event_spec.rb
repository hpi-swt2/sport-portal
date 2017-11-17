require'rails_helper'

describe "new event page", type: :feature do
	
	it "should render without an error" do
		visit new_event_path
	end

	it "should be possible to create a deadline for an event" do
		visit new_event_path

		fill_in "event_deadline", with: "2018/11/16" 

		click_button "Create Event"

		visit events_path

		expect(page).to have_content("2018-11-16")
	end

end