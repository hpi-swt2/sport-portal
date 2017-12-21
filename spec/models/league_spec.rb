# == Schema Information
#
# Table name: events
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  discipline       :string
#  player_type      :integer          not null
#  max_teams        :integer
#  game_mode        :integer          not null
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  startdate        :date
#  enddate          :date
#  deadline         :date
#  gameday_duration :integer
#  owner_id         :integer
#

require 'rails_helper'

describe 'League model', type: :model do

  let(:league) { FactoryBot.build(:league) }
  it 'is valid when produced by a factory' do
    league = FactoryBot.build(:league)
    expect(league).to be_valid
  end

  it 'should not validate without gameday duration' do
    league = FactoryBot.build(:league, gameday_duration: nil)
    expect(league).to_not be_valid
  end
  describe 'gameday date calculation' do
    let(:league) { FactoryBot.build(:league, startdate: Date.parse('24.12.2017'), gameday_duration: 7) }

    it 'calculates gameday dates correctly' do
      expect(league.date_for_gameday 1).to eq Date.parse('24.12.2017')
      expect(league.date_for_gameday 2).to eq Date.parse('31.12.2017')
    end
  end
  describe 'Generating league schedule with default values' do
    let(:league) { league = FactoryBot.create(:league_with_teams)
                   league.generate_schedule
                   league}
    let(:matches) { league.matches }
    let(:home_teams) { matches.map(&:team_home) }
    let(:away_teams) { matches.map(&:team_away) }
    #The following line creates a hash in this matter {team=> occurrences of team} i.e. {Team:1 => 2, Team:2 =>2, etc.}
    let(:all_teams_with_occurrences) { Hash[(home_teams + away_teams).group_by { |x| x }.map { |k, v| [k, v.count] }] }
    subject { matches }

    it 'has correct amount of teams' do
      expect(league.teams.length).to be 5
    end
    it 'does create matches' do
      expect(matches.length).to be > 0
    end

    it 'does create 10 matches' do
      expect(matches.length).to be 10
    end
    it 'incorporates all teams into the schedule' do
      expect(all_teams_with_occurrences.length).to be 5
    end

    it 'makes every single team play exactly 4 times' do
      all_teams_with_occurrences.each do |team, occurrence|
        expect(occurrence).to be 4
      end
    end

    it 'does only let half as many matches as teams play per gameday' do
      5.times do |gameday|
        gameday += 1 #gamedays are from 1 to 5 not 0 to 4
        gameday_matches = matches.select { |match| match.gameday == gameday }
        expect(gameday_matches.length).to be 2
      end
    end
  end
end
