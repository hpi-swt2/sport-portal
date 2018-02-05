require 'rails_helper'

RSpec.describe "matches/edit_results", type: :view do
  before(:each) do
    @match = assign(:match, FactoryBot.create(:match, :with_results))

    @ability = Object.new
    @ability.extend(CanCan::Ability)
    @match = assign(:current_ability, @ability)
    render
  end

  it "renders a input form" do
    expect(rendered).to have_css("form[action='#{match_path(@match)}'][method='post']", count: 2)
  end

  it "has score home and score away input fields" do
    expect(rendered).to have_xpath("//div[@class='result']//input[@type='text' and @value='#{@match.game_results.first.score_home}']")
    expect(rendered).to have_xpath("//div[@class='result']//input[@type='text' and @value='#{@match.game_results.first.score_away}']")
  end

  it "has buttons to add and remove results" do
    expect(rendered).to have_xpath("//a[@href='#' and contains(@class,'remove') and contains(@class,'btn')]")
    expect(rendered).to have_xpath("//a[@href='#' and contains(@class,'add') and contains(@class,'btn')]")

    #Noscript buttons
    expect(rendered).to have_xpath("//a[@href='#{add_game_result_match_path(@match)}']")
    expect(rendered).to have_xpath("//a[@href='#{remove_game_result_match_path(id: @match.id, result_id: @match.game_results.first.id)}']")
  end

  context 'can confirm result' do
    before(:each) do
      @ability.can :confirm, GameResult
      render
    end

    it 'should have a confirm button' do
      expect(rendered).to have_xpath("//a[@href=#{confirm_game_result_match(match, match.game_results.first)}]")
    end
  end

  context 'cannot confirm result' do
    before(:each) do
      @ability.can :confirm, GameResult
      render
    end

    it 'should not have a confirm button' do
      expect(rendered).not_to have_xpath("//a[@href=#{confirm_game_result_match(match, match.game_results.first)}]")
    end
  end
end
