require 'rails_helper'

RSpec.describe "matches/edit_results", type: :view do
  let(:match) { FactoryBot.create(:match, :with_results) }

  before(:each) do
    @match = assign(:match, match)
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
  end

  it "renders a input form" do
    render

    expect(rendered).to have_css("form[action='#{update_results_match_path(@match)}']")
  end

  it "has score home and score away input fields" do
    render

    expect(rendered).to have_xpath("//div[@class='result']//input[@type='number' and @value='#{@match.game_results.first.score_home}']")
    expect(rendered).to have_xpath("//div[@class='result']//input[@type='number' and @value='#{@match.game_results.first.score_away}']")
  end

  it "has buttons to add and remove results" do
    render

    expect(rendered).to have_xpath("//a[@href='#' and contains(@class,'remove') and contains(@class,'btn')]")
    expect(rendered).to have_xpath("//a[@href='#' and contains(@class,'add') and contains(@class,'btn')]")

    #Noscript buttons
    expect(rendered).to have_xpath("//a[@href='#{add_game_result_match_path(@match)}']")
    expect(rendered).to have_xpath("//a[@href='#{remove_game_result_match_path(id: @match.id, result_id: @match.game_results.first.id)}']")
  end

  context 'can confirm result' do
    before(:each) do
      @ability.can :confirm_scores, Match
    end

    it 'should have a confirm button' do
      render
      expect(rendered).to have_xpath("//a[@href='#{confirm_scores_match_path(match)}']")
    end
  end

  context 'cannot confirm result' do
    before(:each) do
      @ability.cannot :confirm_scores, Match
    end

    it 'should not have a confirm button' do
      expect(rendered).not_to have_xpath("//a[@href='#{confirm_scores_match_path(match)}']")
    end
  end

  context 'game result is not confirmed' do
    before(:each) do
      allow_any_instance_of(Match).to receive(:scores_confirmed?).and_return(false)
    end

    it 'should not have a confirmed check' do
      render
      expect(rendered).not_to have_xpath("//i[@class='fa fa-check']")
    end
  end

  context 'game result is confirmed' do
    before(:each) do
      allow_any_instance_of(Match).to receive(:scores_confirmed?).and_return(true)
    end

    it 'should have a confirmed check' do
      render
      expect(rendered).to have_xpath("//i[@class='fa fa-check']")
    end
  end
end
