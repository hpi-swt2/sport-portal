require 'rails_helper'

RSpec.describe "matches/show", type: :view do
  let(:match) { FactoryBot.create(:match, :with_results) }

  before(:each) do
    @ability = Object.new
    @ability.extend(CanCan::Ability)
    controller.stub(:current_ability) { @ability }
    @match = match
  end

  it "renders the gameday of the match" do
    render
    expect(rendered).to have_content(@match.gameday_number)
  end

  it "render the dates for the according gameday" do
    render
    expect(rendered).to have_content(@match.gameday.starttime.strftime("%d.%m.%y"))
    expect(rendered).to have_content(@match.gameday.endtime.strftime("%d.%m.%y"))
  end

  it "renders attributes for simple match" do
    render

    expect(rendered).to have_content(match.place, count: 1)
    expect(rendered).to have_xpath("//table/tbody/tr/td", text: match.game_results.first.score_home, minimum: 1)
    expect(rendered).to have_xpath("//table/tbody/tr/td", text: match.game_results.first.score_away, minimum: 1)
    expect(rendered).to have_css("a[href='#{team_path(match.team_home)}']", count: 1)
    expect(rendered).to have_css("a[href='#{team_path(match.team_away)}']", count: 1)
  end

  it "renders no participant link when there is no participant" do
    match.team_home = nil
    match.team_away = nil
    render

    expect(rendered).to have_content('---', count: 2)
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
