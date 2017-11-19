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

	it "should be possible to enter a startdate for an event" do
		visit new_event_path

		expect(page).to have_field("Startdate")
	end

	it "should be possible to enter a enddate for an event" do
		visit new_event_path

		expect(page).to have_field("Enddate")
	end

	it "should be possible to enter a duration for an event" do
		visit new_event_path

		expect(page).to have_field("Duration")
	end

	it "should be possible to store the date changes persistent" do
		visit new_event_path

		fill_in "event_startdate", with: "2018/12/01"
		fill_in "event_enddate", with: "2018/12/05"
		fill_in "event_duration", with: 5

		click_button "Create Event"

		expect(page).to have_content("2018-12-01")
		expect(page).to have_content("2018-12-05")
		expect(page).to have_content("5")

	end
end