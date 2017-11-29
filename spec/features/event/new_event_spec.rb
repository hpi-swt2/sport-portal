require'rails_helper'

describe "new event page", type: :feature do
	
	it "should render without an error" do
		visit new_event_path
	end

	it "should be possible to enter date conditions for an event" do
		visit new_event_path

		expect(page).to have_field('event_deadline')
		expect(page).to have_field('event_startdate')
		expect(page).to have_field('event_enddate')
  end

  it "should have a disabled field for event duration" do
  	visit new_event_path

  	expect(page).to have_field('event_duration', :disabled => true)
  end

  it "should have a dropdown menu for type" do
		visit new_event_path

    expect(page).to have_select('event_type', :options => ['----', 'Tournament', 'League'])
  end

end