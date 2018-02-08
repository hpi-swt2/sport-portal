require 'rails_helper'

RSpec.describe 'events/schedule', type: :view do

  describe 'page layout' do
    before :each do
      @admin = FactoryBot.create(:admin)
      sign_in @admin
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

    it 'has input field for gameday dates with correct dates' do
      render
      expect(rendered).to have_selector("input[value='24.12.2017']")
      expect(rendered).to have_selector("input[value='31.12.2017']")
    end

    describe 'authorization for edit date button' do
      before(:each) do
        @user = FactoryBot.create(:user)
        sign_in @user
      end

      it 'has edit button for gameday dates for signed-in users who are organizers of the league' do
        @league.organizers << Organizer.new(user: @user, event: @league)
        render
        expect(rendered).to have_selector(:link_or_button, t('events.schedule.edit_date'))
      end

      it 'does not have edit button for gameday dates for signed-out users' do
        sign_out @user
        render
        expect(rendered).not_to have_selector(:link_or_button, t('events.schedule.edit_date'))
      end

      it 'does not have edit button for gameday dates for signed-in users without the required rights' do
        render
        expect(rendered).not_to have_selector(:link_or_button, t('events.schedule.edit_date'))
      end
    end

    it 'has show button for matches' do
      render
      expect(rendered).to have_selector(:link_or_button, t('helpers.links.show'))
    end

    it 'has a delete button for matches when you are an admin' do
      render
      expect(rendered).to have_selector(:link_or_button, t('helpers.links.destroy'))
    end
  end

  describe 'authorization for delete button' do
    before(:each) do
      @user = FactoryBot.create(:user)
      sign_in @user
    end

    it 'has no delete button for normal signed in user' do
      expect(rendered).not_to have_selector(:link_or_button, t('helpers.links.destroy'))
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


end
