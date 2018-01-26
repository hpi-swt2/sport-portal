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
    expect(current_path).to eq("/matches/new")
    click_link_or_button('edit_results')
    expect(current_path).to match(/\/matches\/\d+\/edit_results/)
    click_link_or_button('add_game_result')

    page.all('input').each do |each|
      if(each[:id] != nil)
        if each[:id].include? 'score_home'
          fill_in(each[:id], '11')
        end
        if each[:id].include? 'score_away'
          fill_in(each[:id], '4')
        end
      end
    end

    click_link_or_button(I18n.t("helpers.submit.update", model: Match.model_name.human))
  end
end
