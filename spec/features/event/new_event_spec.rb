require'rails_helper'

describe "new event page", type: :feature do
  before(:each) do
    @user = FactoryBot.create :user
    sign_in @user
  end
	
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

    expect(page).to have_select('event_type', :options => [I18n.t('events.new.select_type'), 'Tournament', 'League'])
  end

  it "should be possible to create a date conditions for an event" do
		visit new_event_path
    fill_in "event_name", with: "name"
    fill_in "event_discipline", with: "soccer"
    select "Tournament", :from => "event_type"
    select "Ko", :from => "event_game_mode_tournament"
    select "Single", :from => "event_player_type"
    fill_in "event_max_teams", with: "5"

		fill_in "event_deadline", with: Date.tomorrow.to_s
		fill_in "event_startdate", with: (Date.tomorrow + 2).to_s
		fill_in "event_enddate", with: (Date.tomorrow + 3).to_s

		find('input[type="submit"]').click

    expect(page).to have_current_path(/.*\/(events|tournaments|leagues)\/\d+/)
		expect(page).to have_content(Date.tomorrow.to_s)
		expect(page).to have_content((Date.tomorrow + 2).to_s)
		expect(page).to have_content((Date.tomorrow + 3).to_s)
  end

end