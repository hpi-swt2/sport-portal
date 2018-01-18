require 'rails_helper'
require 'views/events/form_examples'

RSpec.describe 'events/edit', type: :view do

  before(:each) do
    @user = FactoryBot.create :user
    @admin = FactoryBot.create :admin
    sign_in @user
  end

  context 'League' do
    before(:each) do
      @event = assign(:event, FactoryBot.create(:league))
      @event.editors << @user
    end

    it_should_behave_like 'an event form', for_class: League, path: :edit, with: [:dates, :capacity, :gameday_duration]

  end

  context 'Tournament' do
    before(:each) do
      @event = assign(:event, FactoryBot.create(:tournament))
      @event.editors << @user
    end

    it_should_behave_like 'an event form', for_class: Tournament, path: :edit,  with: [:dates, :capacity]

  end

  context 'Rankinglist' do
    before(:each) do
      @event = assign(:event, FactoryBot.create(:rankinglist))
      @event.editors << @user
    end

    it_should_behave_like 'an event form', for_class: Rankinglist, path: :edit

  end

end
