require 'rails_helper'

RSpec.describe "events/overview", type: :view do
  before(:each) do
    @event = FactoryBot.create(:event)
    assign(:event, @event)

    for each in 1..3 do
      @event.teams << FactoryBot.create(:team)
    end
  end

  it "renders a table with correct column titles" do
    render
    expect(rendered).to have_table
    translatedTeam = I18n.t 'events.overview.teamColumn'
    expect(rendered).to have_xpath("//table/thead/tr/th[contains(.,'" + translatedTeam + "')]")
    translatedStanding = I18n.t 'events.overview.standingColumn'
    expect(rendered).to have_xpath("//table/thead/tr/th[contains(.,'" + translatedStanding + "')]")
  end

  it "renders a table with correct amount of rows" do
    render
    expect(rendered).to have_table
    expect(rendered).to have_xpath("//table/tbody/tr", count: @event.teams.length)
  end

end
