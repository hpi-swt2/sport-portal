require 'rails_helper'

describe 'Rankinglists', type: :feature do

  before :each do
    @event = FactoryBot.create :rankinglist
  end

  it 'should render without an error' do
    visit event_ranking_path(@event)
  end

  it 'can have matches that influence the score of a participant' do
    @user = FactoryBot.create :user
    @user2 = FactoryBot.create :user
    sign_in @user
    sign_in @user2

    @event.add_participant @user
    @event.add_participant @user2
    visit event_path(@event)
    click_link_or_button('duel_participant')
    click_link_or_button('edit_results')
    click_link_or_button('add_game_result')

    page.all('input')each do | each |
      if each[:id].include? 'score_home' do
        fill_in
      end
    end
  end
end
