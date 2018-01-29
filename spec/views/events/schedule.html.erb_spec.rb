require 'rails_helper'

RSpec.describe 'events/schedule', type: :view do

  describe 'page layout' do
    before :each do
      @league = FactoryBot.create(:league, :with_teams,
                                  deadline: Date.parse('23.12.2017'),
                                  startdate: Date.parse('24.12.2017'),
                                  enddate: Date.parse('31.12.2017'),
                                  gameday_duration: 7)
      @league.generate_schedule
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

  describe 'linktext for single player league' do
    before(:each) {
      @league = FactoryBot.create :league, :single_player
      @user = FactoryBot.create :user
      @another_user = FactoryBot.create :user

      @league.add_participant(@user)
      @league.add_participant(@another_user)
      @league.generate_schedule

      assign(:event, @league)
      assign(:schedule_type, 'league')
      assign(:matches, @league.matches)
    }
    it 'has link with player name' do
      render

      expect(rendered).to have_selector(:link_or_button, @user.name)
    end

    it 'links to player page' do
      render

      expect(rendered).to have_selector :link, @user.name, href: user_path(@user)
    end
  end

  it 'has input fields for gameday dates' do
    render
    expect(rendered).to have_field :start_time
    expect(rendered).to have_field :endtime_time
  end

  it 'has input field for gameday dates with correct dates' do
    render
    expect(rendered).to have_selector("input[value='24.12.2017']")
    expect(rendered).to have_selector("input[value='31.12.2017']")
  end

  it 'has edit button for gameday dates' do
    render
    expect(rendered).to have_selector(:link_or_button, t('events.schedule.edit_date'))
  end
end
