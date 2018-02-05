# == Schema Information
#
# Table name: matches
#
#  id             :integer          not null, primary key
#  place          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  team_home_id   :integer
#  team_away_id   :integer
#  event_id       :integer
#  points_home    :integer
#  points_away    :integer
#  gameday_number :integer
#  team_home_type :string           default("Team")
#  team_away_type :string           default("Team")
#  index          :integer
#  gameday_id     :integer
#  start_time     :datetime         default(NULL)
#

require 'rails_helper'

RSpec.describe Match, type: :model do
  it 'is valid when produced by a factory' do
    match = FactoryBot.build(:match)
    expect(match).to be_valid
  end

  it 'can have another match as one side' do
    match_a = FactoryBot.create(:match)
    match_b = FactoryBot.create(:match)
    match_a.team_home = match_b
    match_a.save
    match_a.reload
    expect(match_a.team_home).to eq(match_b)
  end

  describe '#calculate_points' do

    context 'no team has a score' do
      let(:match) { FactoryBot.build(:match, :empty_points) }
      it "should not change points" do
        match.calculate_points
        expect(match.points_home).to be_nil
        expect(match.points_away).to be_nil
      end
    end

    context 'one team has a score' do
      let(:match) { FactoryBot.create(:match, :with_results) }

      it "should not change the points if only home has a score" do
        result = match.game_results.first
        result.score_home = 1
        result.score_away = nil
        result.save!
        match.reload

        match.calculate_points
        expect(match.points_home).to be_nil
        expect(match.points_away).to be_nil
      end

      it "should not change the points if only away has a score" do
        result = match.game_results.first
        result.score_home = nil
        result.score_away = 1
        result.save!
        match.reload

        match.calculate_points
        expect(match.points_home).to be_nil
        expect(match.points_away).to be_nil
      end
    end

    context 'both teams have a score' do
      let(:match) { FactoryBot.create(:match, :with_results) }

      it "should give the winner 3 points and the loser zero" do
        result = match.game_results.first
        result.score_home = 1
        result.score_away = 0
        result.save!
        match.reload

        match.calculate_points
        expect(match.points_home).to eq(3)
        expect(match.points_away).to eq(0)

        result.score_home = 0
        result.score_away = 1
        result.save!
        match.reload

        match.calculate_points
        expect(match.points_home).to eq(0)
        expect(match.points_away).to eq(3)
      end

      it "should give both 1 points for a draw" do
        result = match.game_results.first
        result.score_home = 1
        result_score_away = 1
        result.save!
        match.reload

        match.calculate_points
        expect(match.points_home).to eq(1)
        expect(match.points_away).to eq(1)
      end
    end
  end

  describe '#opponent_of' do
    before :each do
      @other_team = FactoryBot.create(:team)
    end

    describe 'given a match with explicit participants' do
      before :each do
        @match = FactoryBot.create(:match)
      end

      it 'should return the opponent of a participant' do
        expect(@match.opponent_of(@match.team_home)).to eq(@match.team_away)
        expect(@match.opponent_of(@match.team_away)).to eq(@match.team_home)
      end

      it 'should return nil given an unrelated team' do
        expect(@match.opponent_of(@other_team)).to be_nil
      end
    end

    describe 'given a match with implicit participants' do
      before :each do
        @match_result_a =  FactoryBot.create(:match_result)
        @match_result_b =  FactoryBot.create(:match_result)
        @match = FactoryBot.create(:match, team_home: @match_result_a, team_away: @match_result_b)
      end

      it 'should return nil given any team' do
        expect(@match.opponent_of(@match_result_a.match.team_home)).to be_nil
        expect(@match.opponent_of(@match_result_a.match.team_away)).to be_nil
        expect(@match.opponent_of(@match_result_b.match.team_home)).to be_nil
        expect(@match.opponent_of(@match_result_b.match.team_away)).to be_nil
        expect(@match.opponent_of(@other_team)).to be_nil
      end

      describe 'given scores have been entered' do
        before :each do
          @game_result_a = FactoryBot.create(:game_result, score_home: 3, score_away: 1, match: @match_result_a.match)
          @game_result_b = FactoryBot.create(:game_result, score_home: 3, score_away: 1, match: @match_result_b.match)
        end

        it 'should return the opponent of a participant' do
          expect(@match.opponent_of(@match_result_a.advancing_participant)).to eq(@match_result_b.advancing_participant)
          expect(@match.opponent_of(@match_result_b.advancing_participant)).to eq(@match_result_a.advancing_participant)
        end
      end
    end
  end

  it "using #update_with_point_recalculation recalculates points if winner changed and points are already known" do
    match = FactoryBot.create(:match)
    result = FactoryBot.build(:game_result, score_home: 1, score_away: 0)

    match.game_results << result

    result.save!
    match.save_with_point_calculation
    expect(match.points_home).to be_present
    expect(match.points_away).to be_present

    update_params = { game_results_attributes: { "0" => { id: result.id, score_home: "0", score_away: "1" } } }
    match.update_with_point_recalculation(update_params)

    match.reload
    result.reload

    expect(result.score_home).to eq(0)
    expect(result.score_away).to eq(1)

    expect(match.points_home).to be < match.points_away
  end

  it 'send notification emails to all members of teams when scheduled' do
    email_count = 2
    ActionMailer::Base.deliveries.clear
    expect { FactoryBot.create(:match) }.to change { ActionMailer::Base.deliveries.length }.by(email_count * 4)
  end

  it 'send notification emails to all members of teams when canceled' do
    match = FactoryBot.create(:match)
    email_count = match.team_home.members.count + match.team_away.members.count
    expect { match.destroy }.to change { ActionMailer::Base.deliveries.length }.by(email_count)
  end

  it 'send notification emails to all members of teams when starttime is changed' do
    match = FactoryBot.create(:match)
    email_count = match.team_home.members.count + match.team_away.members.count
    expect {
      match.start_time = Time.now
      match.save
    }.to change { ActionMailer::Base.deliveries.length }.by(email_count)
  end

  it 'should not send notifications if anything but the starttime is changed' do
    match = FactoryBot.create(:match)
    email_count = match.team_home.members.count + match.team_away.members.count
    expect {
      match.place = "Here"
      match.save
    }.to change { ActionMailer::Base.deliveries.length }.by(0)
  end
end
