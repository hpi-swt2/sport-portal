require 'rails_helper'

describe 'Rankinglists', type: :feature do

  before :each do
    @event = FactoryBot.create :rankinglist
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
    visit edit_results_match_path(@match)
    expect(current_path).to match(/\/matches\/\d+\/edit_results/)
    expect(@match).not_to equal(nil)
    click_link_or_button(I18n.t("helpers.submit.update"))
  end

  context 'elo ranking lists' do
    before(:each) do
      @elo_event = FactoryBot.create :rankinglist, game_mode: Rankinglist.game_modes[:elo], initial_value: 1000
      @user = FactoryBot.create :user
      @user2 = FactoryBot.create :user
      sign_in @user
      sign_in @user2

      @elo_event.add_participant @user
      @elo_event.add_participant @user2

      @match = Match.new(team_home: @elo_event.team_of(@user), team_away: @elo_event.team_of(@user2), event_id: @elo_event)
      @elo_event.matches << @match
      @match.save
      visit edit_results_match_path(@match)

      click_link_or_button('no_script_add_game_result')
    end
    it 'can have matches that adjust the elo if the home participant wins' do
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
      click_link_or_button(I18n.t("helpers.submit.update"))
      participant = @elo_event.participants.where("team_id = ?", @elo_event.team_of(@user)).first
      participant2 = @elo_event.participants.where("team_id = ?", @elo_event.team_of(@user2)).first
      expect(participant.rating).to eq(1016)
      expect(participant2.rating).to eq(984)
    end

    it 'can have matches that adjust the elo if the away participant wins' do
      page.all('input').each do |each|
        if (each[:id] != nil)
          if each[:id].include? 'score_home'
            fill_in(each[:id], with: '4')
          end
          if each[:id].include? 'score_away'
            fill_in(each[:id], with: '11')
          end
        end
      end
      click_link_or_button(I18n.t("helpers.submit.update"))
      participant = @elo_event.participants.where("team_id = ?", @elo_event.team_of(@user)).first
      participant2 = @elo_event.participants.where("team_id = ?", @elo_event.team_of(@user2)).first
      expect(participant.rating).to eq(984)
      expect(participant2.rating).to eq(1016)
    end

    it 'can have matches that adjust the elo if the game is a draw' do
      page.all('input').each do |each|
        if (each[:id] != nil)
          if each[:id].include? 'score_home'
            fill_in(each[:id], with: '4')
          end
          if each[:id].include? 'score_away'
            fill_in(each[:id], with: '4')
          end
        end
      end
      click_link_or_button(I18n.t("helpers.submit.update"))
      participant = @elo_event.participants.where("team_id = ?", @elo_event.team_of(@user)).first
      participant2 = @elo_event.participants.where("team_id = ?", @elo_event.team_of(@user2)).first
      expect(participant.rating).to eq(1000)
      expect(participant2.rating).to eq(1000)
    end
  end
end
