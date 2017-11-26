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

  it "should have a dropdown menu for type" do
		visit new_event_path

    expect(page).to have_select('event_type', :options => ['----', 'Tournament', 'League'])
  end

  it "should calculate the duration correctly" do
    visit new_event_path


  end

end