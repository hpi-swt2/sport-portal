# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  name                 :string
#  description          :text
#  discipline           :string
#  player_type          :integer          not null
#  max_teams            :integer
#  game_mode            :integer          not null
#  type                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  startdate            :date
#  enddate              :date
#  deadline             :date
#  gameday_duration     :integer
#  owner_id             :integer
#  initial_value        :float
#  selection_type       :integer          default("fcfs"), not null
#  min_players_per_team :integer
#  max_players_per_team :integer
#  matchtype            :integer
#  bestof_length        :integer          default(1)
#  game_winrule         :integer
#  points_for_win       :integer          default(3)
#  points_for_draw      :integer          default(1)
#  points_for_lose      :integer          default(0)
#  image_data           :text
#

require 'rails_helper'
require 'models/actual_event_examples'

describe 'League model', type: :model do

  let(:league) { FactoryBot.build(:league) }
  it 'is valid when produced by a factory' do
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
<<<<<<< HEAD
  describe 'Generating league schedule' do
    let(:league) { league = FactoryBot.create(:league, :with_teams)
                   league.game_mode = gamemode
                   league.generate_schedule
                   league }
=======

  describe 'Generating league schedule with default values' do

    let(:league) { league = FactoryBot.create(:league_with_teams)
    league.game_mode = gamemode
    league.generate_schedule
    league }

>>>>>>> 98bf5ea... Rebased tests to Ref #295 gameday model branch. Ref #139
    let(:matches) { league.all_matches }
    let(:home_teams) { matches.map(&:team_home) }
    let(:away_teams) { matches.map(&:team_away) }
    #The following line creates a hash in this matter {team=> occurrences of team} i.e. {Team:1 => 2, Team:2 =>2, etc.}
    let(:all_teams_with_occurrences) { Hash[(home_teams + away_teams).group_by { |x| x }.map { |k, v| [k, v.count] }] }
    subject { matches }
<<<<<<< HEAD
    context 'round robin' do
      let(:gamemode) { League.game_modes[:round_robin] }
=======

    context 'round robin' do
      let(:gamemode){League.game_modes[:round_robin]}
>>>>>>> 98bf5ea... Rebased tests to Ref #295 gameday model branch. Ref #139

      it 'does create matches' do
        expect(subject.length).to be > 0
      end

      it 'does create the correct amount of matches' do
        expect(subject.length).to be 10
      end

      it 'incorporates all teams into the schedule' do
        expect(all_teams_with_occurrences.length).to be 5
      end

      it 'creates the right amount of gameday' do
        expect(league.gamedays.length).to eq 5
      end

      it 'makes every single team play the right amount of games times' do
        all_teams_with_occurrences.each do |team, occurrence|
          expect(occurrence).to be 4
        end
      end

      it 'does only let half as many matches as teams play per gameday' do
        5.times do |gameday|
          expect(league.gamedays[gameday].matches.length).to eq 2
        end
      end

      it 'has a correct amount of matches' do
        # simple round robin has n((n-1)/2) games
        expect(matches.length).to be league.teams.length * ((league.teams.length - 1) / 2)
      end
    end

    context 'double round robin' do
      let(:gamemode) { League.game_modes[:two_halfs] }

      let(:all_teams_with_home_occurences) { Hash[(home_teams).group_by { |x| x }.map { |k, v| [k, v.count] }] }
      let(:all_teams_with_away_occurences) { Hash[(away_teams).group_by { |x| x }.map { |k, v| [k, v.count] }] }

      it 'makes each team play as home and away just as often' do
        expect(all_teams_with_home_occurences).to eq all_teams_with_away_occurences
      end

      it 'creates the right amount of gamedays' do
        expect(league.gamedays.length).to eq 10
      end

      it 'does only let half as many matches as teams play per gameday' do
        10.times do |gameday|
          expect(league.gamedays[gameday].matches.length).to eq 2
        end
      end

      it 'has double the matches if double round robin is selected' do
        # double round robin has n(n-1) games
        expect(subject.length).to eq(league.teams.length * (league.teams.length - 1))
      end
    end

    context 'swiss system' do
      let(:gamemod){League.game_modes[:swiss_system]}

      let(:amount_playing_teams) { home_teams.length + away_teams.length }

      it 'has an up-to-date schedule' do
        expect(league.is_up_to_date).to be true
      end

      it 'creates 2 matches' do
        expect(league.matches.length).to be 2
      end

      it 'creates a correct amount of matches' do
        expect(league.matches.length).to be (league.teams.length / 2).floor
      end

      it 'incorporates each team to play on the first gameday if team amount is even' do
        expect(amount_playing_teams.length).to be league.teams.length
      end

      it 'incorporates each team except one to play on the first gameday if team amount is uneven' do
        expect(amount_playing_teams.length).to be league.teams.length - 1
      end
    end
  end

  describe "#add_participant" do
    context 'single player event' do
      let(:league) { FactoryBot.create(:league, :single_player) }
      let(:user) { FactoryBot.create(:user) }

      it 'creates a single player team' do
        league.add_participant user

        expect(league.teams.first.single?).to eq true
      end
    end
  end
end
