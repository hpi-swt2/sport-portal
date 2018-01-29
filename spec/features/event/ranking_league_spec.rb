require 'rails_helper'

describe 'League Rankings', type: :feature do

  before(:each) do
    @user = FactoryBot.create :user
  end

  let(:valid_league_attributes) {
    FactoryBot.build(:league, owner: @user, max_teams: 20, game_mode: League.game_modes[:round_robin]).attributes
  }

  it 'should render without an error' do
    event = League.create! valid_league_attributes
    visit leagues_ranking_path(event)
  end
end
