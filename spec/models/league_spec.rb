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
#  initial_value    :float
#  matchtype        :integer
#  bestof_length    :integer          default(1)
#  game_winrule     :integer
#  points_for_win   :integer          default(3)
#  points_for_draw  :integer          default(1)
#  points_for_lose  :integer          default(0)
#  selection_type   :integer          default("fcfs"), not null
#  image_data       :text
#

require 'rails_helper'
require 'models/actual_event_examples'

describe 'League model', type: :model do

  let(:league) { FactoryBot.build(:league) }
  it 'is valid when produced by a factory' do
    league = FactoryBot.build(:league)
    expect(league).to be_valid
  end

  it_should_behave_like 'an actual event', for_class: :league

  describe 'gameday duration' do
    it 'should not validate without it' do
      league.gameday_duration = nil
      expect(league).to_not be_valid
    end

    it 'doesnt allow negative values' do
      league.gameday_duration = -1
      expect(league).to_not be_valid
    end

    it 'doesnt allow extremely big numbers' do
      league.gameday_duration = 1000000000000000000000000000000000000000000000000
      expect(league).to_not be_valid
    end
  end

  describe 'gameday date calculation' do
    let(:league) { FactoryBot.build(:league, startdate: Date.parse('24.12.2017'), gameday_duration: 7) }

    it 'calculates gameday dates correctly' do
      expect(league.startdate_for_gameday 1).to eq Date.parse('24.12.2017')
      expect(league.startdate_for_gameday 2).to eq Date.parse('31.12.2017')
      expect(league.enddate_for_gameday 1).to eq Date.parse('30.12.2017')
    end
  end
  describe 'Generating league schedule with default values' do
    let(:league) { league = FactoryBot.create(:league, :with_teams)
                   league.game_mode = League.game_modes[:round_robin]
                   league.generate_schedule
                   league }
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

    it 'uses round robin if its selected' do
      # simple round robin has n((n-1)/2) games
      expect(matches.length).to be league.teams.length * ((league.teams.length - 1) / 2)
    end

    it 'has double the matches if double round robin is selected' do
      new_league = FactoryBot.create(:league, :with_teams)
      new_league.game_mode = League.game_modes[:two_halfs]
      new_league.generate_schedule
      # double round robin has n(n-1) games
      expect(new_league.matches.length).to eq(new_league.teams.length * (new_league.teams.length - 1))
    end
  end
end
