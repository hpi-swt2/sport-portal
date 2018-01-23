require 'rails_helper'

RSpec.describe 'events/schedule', type: :view do

  describe 'schedule' do
    before :each do
      @league = FactoryBot.create(:league, :with_matches,
                                  deadline: Date.parse('23.12.2017'),
                                  startdate: Date.parse('24.12.2017'),
                                  enddate: Date.parse('31.12.2017'),
                                  gameday_duration: 7)
      assign(:event, @league)
      assign(:schedule_type, 'league')
      assign(:matches, @league.matches)
    end

    it 'renders without errors' do
      render
    end

    it 'has correct gameday date for gamedays' do
      render
      expect(rendered).to have_text "- 24.12. #{t 'events.schedule.to'} 30.12."
    end
  end

  describe "linktext" do
    before(:each){
      @league = FactoryBot.create :league, :single_player, :with_users
      @league.generate_schedule

      assign(:event, @league)
      assign(:schedule_type, 'league')
      assign(:matches, @league.matches)
    }
    context "single player league" do
      it 'has link with player name' do
        render

        expect(rendered).to have_selector(:link_or_button, @league.participants.first.name)
      end
    end
  end
end
