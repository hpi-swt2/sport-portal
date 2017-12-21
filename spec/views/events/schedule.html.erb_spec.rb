require 'rails_helper'

RSpec.describe 'events/schedule', type: :view do

  before :each do
    @league = FactoryBot.create(:league, :with_matches, startdate: Date.parse('24.12.2017'), enddate: Date.parse('31.12.2017'), gameday_duration: 7)
    assign(:event, @league)
    assign(:matches, @league.matches)
  end

  it 'renders without errors' do
    render
  end

  it 'has correct gameday date for gamedays' do
    render
    expect(rendered).to have_text '24.12. bis 30.12.'
  end
end
