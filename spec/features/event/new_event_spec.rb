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

  context "for a league" do
    let(:new_path) {new_event_path(type: "league")} # /new?type=league

    it "should render without errors" do
      visit new_path
      end

    it "should be possible to enter date conditions" do
      visit new_path

      expect(page).to have_field('event_deadline')
      expect(page).to have_field('event_startdate')
      expect(page).to have_field('event_enddate')
    end

    it "should have a field for league duration" do
      visit new_path

      expect(page).to have_field('event_duration')
    end

    it "should be possible to create a date conditions" do
      visit new_path
      fill_in "event_name", with: "name"
      fill_in "event_discipline", with: "soccer"
      select "Round robin", from: "event_game_mode_league"
      select "Single", from: "event_player_type"
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

  context "for a tournament" do
    let(:new_path) {new_event_path(type: "tournament")} # /new?type=tournament

    it "should render without errors" do
      visit new_path
    end

    it "should be possible to enter date conditions" do
      visit new_path

      expect(page).to have_field('event_deadline')
      expect(page).to have_field('event_startdate')
      expect(page).to have_field('event_enddate')
    end

    it "should have a field for league duration" do
      visit new_path

      expect(page).to have_field('event_duration')
    end

    it "should be possible to create a date conditions" do
      visit new_path
      fill_in "event_name", with: "name"
      fill_in "event_discipline", with: "soccer"
      select "Ko", from: "event_game_mode_tournament"
      select "Single", from: "event_player_type"
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


end
