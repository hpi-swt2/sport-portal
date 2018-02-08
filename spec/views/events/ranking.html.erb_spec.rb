require 'rails_helper'

RSpec.describe "events/ranking", type: :view do

  before(:each) do
    league = FactoryBot.create(:league, :with_teams)
    assign(:event, league)
    assign(:ranking_entries, league.get_ranking)
  end

  it 'renders without errors' do
    render
  end

end
