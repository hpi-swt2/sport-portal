require 'rails_helper'

describe 'Event Rankings', type: :feature do

  it 'should render without an error' do
    visit ranking_event_path
  end
end