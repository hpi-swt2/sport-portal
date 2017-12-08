require 'rails_helper'

describe "new event page", type: :feature do
  before(:each) do
    @user = FactoryBot.create :user
    sign_in @user
  end

  after(:each) do
    Event.delete_all
    @user.destroy
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

  it "should have a field for event duration" do
    visit new_event_path

    expect(page).to have_field('event_duration')
  end

  it "should have a dropdown menu for type" do
    visit new_event_path

    expect(page).to have_select('event_type',
                                options: [I18n.t('events.new.select_type'),
                                          I18n.t('events.Tournament'),
                                          I18n.t('events.League'),
                                          I18n.t('events.Rankinglist')])
  end

  context "for ranking lists" do
    before :each do
      visit new_event_path
      select I18n.t('events.Rankinglist'), from: "event_type"
    end

    it "should show a field for choosing the ranking metric" do
        expect(page).to have_field('event_metric')
    end

    it "should show a field for choosing the initial value of the ranking metric" do
      expect(page).to have_field('event_initial_value')
    end

    it "should not show a field for defining a deadline" do
      expect(page).to have_field('event_deadline', disabled: 'disabled')
    end

    it "should not show a field for defining a enddate " do
      expect(page).to have_field('event_enddate', disabled: 'disabled')
    end

    it "should not show a field for defining a startdate" do
      expect(page).to have_field('event_startdate', disabled: 'disabled')
    end

    it "should not show a field for defining whether its a team or single player sport" do
      expect(page).to have_field('event_player_type', disabled: 'disabled')
    end

    it "should not show a field for the duration" do
      expect(page).to have_field('event_duration', disabled: 'disabled')
    end

  end
  it "should be possible to create a date conditions for an event" do
    visit new_event_path
    fill_in "event_name", with: "name"
    fill_in "event_discipline", with: "soccer"
    select I18n.t('events.Tournament'), from: "event_type"
    select I18n.t('events.gamemode.ko'), from: "event_game_mode_tournament"
    select I18n.t('activerecord.attributes.event.player_types.single'), from: "event_player_type"
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
