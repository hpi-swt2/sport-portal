require 'rails_helper'

describe Tournament, type: :model do

  it 'is valid when produced by a factory' do
    tournament = FactoryBot.build(:tournament)
    expect(tournament).to be_valid
  end

end
