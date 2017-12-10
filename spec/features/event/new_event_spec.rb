require 'rails_helper'

describe 'new event page', type: :feature do
  before(:each) do
    @user = FactoryBot.create :user
    sign_in @user
  end

  after(:each) do
    Event.delete_all
    @user.destroy
  end

  it 'should render without an error' do
    visit new_event_path
  end

  it 'should be possible to enter date conditions for an event' do
    visit new_event_path

    expect(page).to have_field('event_deadline')
    expect(page).to have_field('event_startdate')
    expect(page).to have_field('event_enddate')
  end

  it 'should have a field for event duration' do
    visit new_event_path

    expect(page).to have_field('event_duration')
  end

  it 'should be possible to create a date conditions for an event' do
    visit new_tournament_path
    fill_in Event.human_attribute_name(:name), with: 'name'
    fill_in Event.human_attribute_name(:discipline), with: 'soccer'
    select 'Ko', from: Event.human_attribute_name(:game_mode)
    select 'Single', from: Event.human_attribute_name(:player_type)
    fill_in Event.human_attribute_name(:max_teams), with: '5'

    fill_in Event.human_attribute_name(:deadline), with: Date.tomorrow.to_s
    fill_in Event.human_attribute_name(:startdate), with: (Date.tomorrow + 2).to_s
    fill_in Event.human_attribute_name(:enddate), with: (Date.tomorrow + 3).to_s

    find('input[type="submit"]').click

    expect(page).to have_current_path(/.*\/(events|tournaments|leagues)\/\d+/)
    expect(page).to have_content(Date.tomorrow.to_s)
    expect(page).to have_content((Date.tomorrow + 2).to_s)
    expect(page).to have_content((Date.tomorrow + 3).to_s)
  end
end
