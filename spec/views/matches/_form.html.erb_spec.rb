require 'rails_helper'

RSpec.describe "matches/_form", type: :view do
  before(:each) do
    @match = assign(:match, FactoryBot.create(:match, :with_results))
  end

  it "renders a input form" do
    render partial: "form", locals: { is_creation_form: false }

    expect(rendered).to have_css("form[action='#{match_path(@match)}'][method='post']", count: 1)
  end

  it "has score home and score away input fields" do
    render partial: "form", locals: { is_creation_form: false }

    expect(rendered).to have_xpath("//div[@class='result']//input[@type='text' and @value='#{@match.game_results.first.score_home}']")
    expect(rendered).to have_xpath("//div[@class='result']//input[@type='text' and @value='#{@match.game_results.first.score_away}']")
  end

  it "has buttons to add and remove results" do
    render partial: "form", locals: { is_creation_form: false }

    expect(rendered).to have_xpath("//a[@href='#' and contains(@class,'remove') and contains(@class,'btn')]")
    expect(rendered).to have_xpath("//a[@href='#' and contains(@class,'add') and contains(@class,'btn')]")

    #Noscript buttons
    expect(rendered).to have_xpath("//a[@href='#{add_game_result_match_path(@match)}']")
    expect(rendered).to have_xpath("//a[@href='#{remove_game_result_match_path(id: @match.id, result_id: @match.game_results.first.id)}']")
  end

  it "has no non-javascript buttons if it is a creation form" do
    render partial: "form", locals: { is_creation_form: true }

    expect(rendered).not_to have_xpath("//a[@href='#{add_game_result_match_path(@match)}']")
    expect(rendered).not_to have_xpath("//a[@href='#{remove_game_result_match_path(id: @match.id, result_id: @match.game_results.first.id)}']")
  end


end
