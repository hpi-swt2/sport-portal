require 'rails_helper'

RSpec.describe "events/edit", type: :view do

  before(:each) do
    @user = FactoryBot.create :user
    sign_in @user
  end

  context "League" do
    before(:each) do
      @event = assign(:event, FactoryBot.create(:league))
      @event.editors << @user
    end

    it "renders the edit event form" do
      render
      expect(rendered).to have_css("form[action='#{league_path(@event)}'][method='post']", count: 1)
    end
  end
  context "Tournament" do
    before(:each) do
      @event = assign(:event, FactoryBot.create(:tournament))
      @event.editors << @user
    end

    it "renders the edit event form" do
      render
      expect(rendered).to have_css("form[action='#{tournament_path(@event)}'][method='post']", count: 1)
    end
  end

end
