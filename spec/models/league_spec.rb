require 'rails_helper'

describe "League model", type: :model do

    it "is valid when produced by a factory" do
      league = FactoryBot.build(:league)
      expect(league).to be_valid
    end

    describe "Generating league schedule with default values" do
      let(:league){league = FactoryBot.create(:league_with_teams)
      league.generate_schedule
      league}
      let(:matches){league.matches}
      let(:home_teams){matches.map(&:team_home)}
      let(:away_teams){matches.map(&:team_away)}
      #The following line creates a hash in this matter {team=> occurrences of team} i.e. {Team:1 => 2, Team:2 =>2, etc.}
      let(:all_teams_with_occurrences){Hash[(home_teams+away_teams).group_by {|x| x}.map {|k,v| [k,v.count]}]}
      subject{matches}
      it "has correct amount of teams" do
        expect(league.teams.length).to be 5
      end
      it "does create matches" do
        expect(matches.length).to be > 0
      end

      it "does create 10 matches" do
        expect(matches.length).to be 10
      end
      it "incorporates all teams into the schedule" do
        expect(all_teams_with_occurrences.length).to be 5
      end

      it "makes every single team play exactly 4 times" do
        all_teams_with_occurrences.each do |team, occurrence|
          expect(occurrence).to be 4
        end
      end

      it "does only let half as many matches as teams play per gameday" do
        league.gamedays.times do |gameday|
          gameday_matches = matches.select{|match| match.gameday==gameday}
          expect(gameday_matches.length).to be <=(league.teams.length/2)
        end
      end

    end
end
