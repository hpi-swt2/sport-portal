require 'rails_helper'

describe 'Event Rankings', type: :feature do

  it 'should render without an error' do
    event = FactoryBot.create :event
    visit event_ranking_path(event)
  end
end