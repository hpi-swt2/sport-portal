require 'rails_helper'

RSpec.describe 'events/_event_cards', type: :view do
  before(:each) do
    @user = assign(:user, FactoryBot.create(:user))
    sign_in @user
  end

  it 'should have a link to create a new tournament' do
    render
    expect(rendered).to have_link I18n.t('events.new_tournament'), href: new_tournament_path
  end

  it 'should have a link to create a new league' do
    render
    expect(rendered).to have_link I18n.t('events.new_league'), href: new_league_path
  end

  it 'should have a link to create a new rankinglist' do
    render
    expect(rendered).to have_link I18n.t('events.new_rankinglist'), href: new_rankinglist_path
  end
end
