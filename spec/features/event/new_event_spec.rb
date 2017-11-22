require'rails_helper'

describe "new event page", type: :feature do
	
	it "should render without an error" do
		visit new_event_path
	end

	it "should be possible to enter date conditions for an event" do
		visit new_event_path

		expect(page).to have_field("Deadline")
		expect(page).to have_field("Startdate")
		expect(page).to have_field("Enddate")
		expect(page).to have_field("Duration")
  end

  it "should be possible to create a date conditions for an event" do
		visit new_event_path

		fill_in "event_deadline", with: "2018/11/16"
		fill_in "event_startdate", with: "2017/12/01"
		fill_in "event_enddate", with: "2017/12/05"
		fill_in "event_duration", with: "5" 

		click_button "Create event"

    expect(page).to have_current_path(/.*\/events\/\d+/)
		expect(page).to have_content("2018-11-16")
		expect(page).to have_content("2017-12-01")
		expect(page).to have_content("2017-12-05")
  end

end