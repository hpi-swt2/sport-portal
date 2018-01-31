require 'rails_helper'

RSpec.describe "matches/edit_results", type: :view do
  before(:each) do
    @match = assign(:match, FactoryBot.create(:match, :with_results))

  end

  it "renders a input form" do
    render

    expect(rendered).to have_css("form[action='#{match_path(@match)}'][method='post']", count: 2)
  end

  it "has score home and score away input fields" do
    render

    expect(rendered).to have_xpath("//div[@class='result']//input[@type='text' and @value='#{@match.game_results.first.score_home}']")
    expect(rendered).to have_xpath("//div[@class='result']//input[@type='text' and @value='#{@match.game_results.first.score_away}']")
  end

  it "has buttons to add and remove results" do
    render

    expect(rendered).to have_xpath("//a[@href='#' and contains(@class,'remove') and contains(@class,'btn')]")
    expect(rendered).to have_xpath("//a[@href='#' and contains(@class,'add') and contains(@class,'btn')]")

    #Noscript buttons
    expect(rendered).to have_xpath("//a[@href='#{add_game_result_match_path(@match)}']")
    expect(rendered).to have_xpath("//a[@href='#{remove_game_result_match_path(id: @match.id, result_id: @match.game_results.first.id)}']")
  end
end
