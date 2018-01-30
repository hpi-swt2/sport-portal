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

    @match = Match.new(team_home: @event.team_of(@user), team_away: @event.team_of(@user2), event_id: @event)
    @event.matches << @match
    expect(current_path).to eq("/matches/new")
    @match.save
    visit match_path(@match)

    click_link_or_button('edit_results')
    expect(current_path).to match(/\/matches\/\d+\/edit_results/)
    click_link_or_button('no_script_add_game_result')

    page.all('input').each do |each|
      if (each[:id] != nil)
        if each[:id].include? 'score_home'
          fill_in(each[:id], with: '11')
        end
        if each[:id].include? 'score_away'
          fill_in(each[:id], with: '4')
        end
      end
    end
    expect(@event.matches.first).to equal(@match)
    visit add_game_result_match_path(@match)
    expect(current_path).to match(/\/matches\/\d+\/add_game_result/)
    expect(@match).not_to equal(nil)
    click_link_or_button(I18n.t("helpers.submit.update", model: Match.model_name.human))
  end
end
