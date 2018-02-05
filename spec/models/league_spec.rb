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
      expect(league.startdate_for_gameday 0).to eq Date.parse('24.12.2017')
      expect(league.startdate_for_gameday 1).to eq Date.parse('31.12.2017')
      expect(league.enddate_for_gameday 0).to eq Date.parse('30.12.2017')
    end
  end
  describe 'Generating league schedule' do
    let(:league) { league = FactoryBot.create(:league, :with_teams)
                   league.game_mode = gamemode
                   league.generate_schedule
                   league }
    let(:matches) { league.all_matches }
    let(:home_teams) { matches.map(&:team_home) }
    let(:away_teams) { matches.map(&:team_away) }
    #The following line creates a hash in this matter {team=> occurrences of team} i.e. {Team:1 => 2, Team:2 =>2, etc.}
    let(:all_teams_with_occurrences) { Hash[(home_teams + away_teams).group_by { |x| x }.map { |k, v| [k, v.count] }] }
    subject { matches }
    context 'round robin' do
      let(:gamemode) { League.game_modes[:round_robin] }

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
      let(:gamemode) { League.game_modes[:swiss] }

      it 'does not have an up-to-date schedule if the last gameday is in the past' do
        league.gamedays << FactoryBot.create(:gameday)

        last_gameday = league.gamedays.last
        last_gameday.starttime = Date.current - 2.days
        last_gameday.endtime = Date.current - 1.day

        expect(league.is_up_to_date).to be false
      end

      it 'does have an up-to-date schedule if all teams have played against each other' do
        league = FactoryBot.create(:league)
        league.teams = teams = FactoryBot.create_list(:team, 3)
        gamedays = FactoryBot.create_list(:gameday, 3)
        gamedays[0].matches << Match.new(team_home: teams[0], team_away: teams[1], gameday_number: 0)
        gamedays[1].matches << Match.new(team_home: teams[1], team_away: teams[2], gameday_number: 1)
        gamedays[2].matches << Match.new(team_home: teams[0], team_away: teams[2], gameday_number: 2)
        league.gamedays << gamedays

        expect(league.is_up_to_date).to be true
      end

      it 'has an up-to-date schedule if the last gameday is not over yet' do
        league.gamedays << FactoryBot.create(:gameday)

        last_gameday = league.gamedays.last
        last_gameday.starttime = Date.current + 1.day
        last_gameday.endtime = Date.current + 2.days

        expect(league.is_up_to_date).to be true
      end

      it 'allows to check if two teams have already played a match' do
        teams = FactoryBot.create_list(:team, 2)

        expect(league.have_already_played(teams[0], teams[1])).to be false
        expect(league.have_already_played(teams[1], teams[0])).to be false

        league.matches << Match.new(team_home: teams[0], team_away: teams[1], gameday_number: 0)

        expect(league.have_already_played(teams[0], teams[1])).to be true
        expect(league.have_already_played(teams[1], teams[0])).to be true
      end

      context 'update schedule' do
        it 'creates a new gameday' do
          expect { league.update_schedule }.to change { league.gamedays.length }.by 1
        end

        it 'creates a correct amount of matches' do
          expect { league.update_schedule }.to change { league.all_matches.length }.by (league.teams.length / 2).floor
        end

        it 'does not create matches of teams that already played against each other' do
          league.update_schedule
          current_pairings = league.matches.map { |match| Set[match.team_home, match.team_away] }
          expect(current_pairings.uniq.length == current_pairings.length).to be true
        end

        let(:league) {
          league = FactoryBot.create(:league)
          league.game_mode = League.game_modes[:swiss]
          league.teams = FactoryBot.create_list(:team, 6)
          league
        }

        describe "Round 1" do
          let(:gameday) {
            gameday = FactoryBot.build(:gameday)
            teams = league.teams
            match1 = FactoryBot.build(:match, team_home: teams[0], team_away: teams[1], gameday_number: 1, points_home: 3, points_away: 0)
            match1.game_results << FactoryBot.build(:game_result,
                                                    score_home: 25, # team 0
                                                    score_away: 5  # team 1
            )
            match2 = FactoryBot.build(:match, team_home: teams[2], team_away: teams[3], gameday_number: 1, points_home: 3, points_away: 0)
            match2.game_results << FactoryBot.build(:game_result,
                                                    score_home: 26, # team 2
                                                    score_away: 2   # team 3
            )
            match3 = FactoryBot.build(:match, team_home: teams[4], team_away: teams[5], gameday_number: 1, points_home: 3, points_away: 0)
            match3.game_results << FactoryBot.build(:game_result,
                                                    score_home: 15, # team 4
                                                    score_away: 0   # team 5
            )
            gameday.matches << [match1, match2, match3]
            gameday
          }

          before(:each) do
            league.gamedays << gameday
            league.matches << gameday.matches
            league.update_schedule
          end

          let(:sum_distances) {
            ranked_teams = league.get_ranking.map(&:team)
            league.gamedays.last.matches.inject(0) { |sum, match|
              sum + (ranked_teams.index(match.team_home) - ranked_teams.index(match.team_away)).abs
            }
          }

          it 'creates the matches correctly by the ranking' do
            expect(sum_distances).to be <= 5
          end

          describe "Round 2" do
            let(:gameday2) {
              gameday2 = league.gamedays.last
              gameday2.matches[0].game_results << FactoryBot.build(:game_result,
                                                      score_home: 0, # team 2
                                                      score_away: 1000   # team 0
              )
              gameday2.matches[1].game_results << FactoryBot.build(:game_result,
                                                                   score_home: 30, # team 4
                                                                   score_away: 0   # team 1
              )
              gameday2.matches[2].game_results << FactoryBot.build(:game_result,
                                                                   score_home: 1, # team 5
                                                                   score_away: 0   # team 3
              )
              gameday2
            }

            before(:each) do
              league.gamedays << gameday2
              league.matches = gameday.matches + gameday2.matches
              league.update_schedule
            end

            it 'creates the matches correctly by the ranking' do
              expect(sum_distances).to be <= 5
            end
          end
        end
      end

      context 'initial schedule' do
        it 'has an up-to-date schedule' do
          expect(league.is_up_to_date).to be true
        end

        it 'creates a correct amount of matches' do
          expect(league.matches.length).to be (league.teams.length / 2).floor
        end

        let(:amount_playing_teams) { home_teams.length + away_teams.length }

        it 'incorporates each team to play on the first gameday if team amount is even' do
          league = FactoryBot.create(:league)
          league.teams = FactoryBot.create_list(:team, 4)
          league.generate_schedule

          expect(amount_playing_teams).to be league.teams.length
        end

        it 'incorporates each team except one to play on the first gameday if team amount is uneven' do
          league = FactoryBot.create(:league)
          league.teams = FactoryBot.create_list(:team, 5)
          league.generate_schedule

          expect(amount_playing_teams).to be league.teams.length - 1
        end
      end
    end
  end

  describe "#add_participant" do
    context 'single player event' do
      let(:league) { FactoryBot.create(:league, :single_player) }
      let(:user) { FactoryBot.create(:user) }

      it 'creates a single player team' do
        league.add_participant user

        expect(league.teams.first.created_by_event?).to eq true
      end
    end
  end
end
