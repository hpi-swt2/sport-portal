# == Schema Information
#
# Table name: matches
#
#  id                  :integer          not null, primary key
#  place               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  team_home_id        :integer
#  team_away_id        :integer
#  event_id            :integer
#  points_home         :integer
#  points_away         :integer
#  gameday             :integer
#  team_home_type      :string           default("Team")
#  team_away_type      :string           default("Team")
#  index               :integer
#  start_time          :datetime
#  proposed_score_home :integer
#  proposed_score_away :integer
#  proposed_by_id      :integer
#  confirmed_by_id     :integer
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
    subject { -> { match.calculate_points } }

    context 'no team has a score' do
      let(:match) { FactoryBot.build(:match, :empty_points, score_home: nil, score_away: nil) }
      it { is_expected.not_to change { match.points_home } }
      it { is_expected.not_to change { match.points_away } }
    end

    context 'team home has a higher score' do
      let(:match) { FactoryBot.build(:match, :empty_points, score_home: 1, score_away: 0) }
      it { is_expected.to change { match.points_home }.from(nil).to(3) }
      it { is_expected.to change { match.points_away }.from(nil).to(0)  }
    end

    context 'team away has a higher score' do
      let(:match) { FactoryBot.build(:match, :empty_points, score_home: 0, score_away: 1) }
      it { is_expected.to change { match.points_home }.from(nil).to(0) }
      it { is_expected.to change { match.points_away }.from(nil).to(3)  }
    end

    context 'team home and team away have an equal score' do
      let(:match) { FactoryBot.build(:match, :empty_points, score_home: 1, score_away: 1) }
      it { is_expected.to change { match.points_home }.from(nil).to(1) }
      it { is_expected.to change { match.points_away }.from(nil).to(1) }
    end
  end
end
