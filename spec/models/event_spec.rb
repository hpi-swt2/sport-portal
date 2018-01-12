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

describe 'Event model', type: :model do

  let(:event) { FactoryBot.build(:league) }

  it 'should not validate without name' do
    league = FactoryBot.build(:league, name: nil)
    expect(league.valid?).to eq(false)
  end

  it 'should not validate without discipline' do
    league = FactoryBot.build(:league, discipline: nil)
    expect(league.valid?).to eq(false)
  end

  it 'should not validate without game_mode' do
    league = FactoryBot.build(:league, game_mode: nil)
    expect(league.valid?).to eq(false)
  end

  it 'should have an attribute deadline' do
    date = Date.tomorrow
    expect(event.deadline).to eq date

    event.deadline = nil
    expect(event).not_to be_valid
  end

  it 'should have an attribute startdate' do
    date = Date.current + 2
    expect(event.startdate).to eq date

    expect(event).to be_valid
    event.startdate = nil
    expect(event).not_to be_valid
  end

  it 'should have an attribute enddate' do
    date = Date.current + 3
    expect(event.enddate).to eq date

    expect(event).to be_valid
    event.enddate = nil
    expect(event).not_to be_valid
  end

  it 'should not be possible to have an enddate, that is before the startdate' do
    expect(event).to be_valid
    event.enddate = Date.current
    expect(event).not_to be_valid
  end

  it 'should be possible to get the duration in day of an event' do
    expect(event.duration).to eq(2)
  end

  it 'should only show active events' do
    new_event = FactoryBot.create(:event, deadline: Date.current)
    old_event = FactoryBot.create(:event, deadline: Date.yesterday)

    expect(Event.active).to include(new_event)
    expect(Event.active).not_to include(old_event)
    expect(Event.all).to include(new_event, old_event)
  end

  it 'should have an association participants' do
    relation = Event.reflect_on_association(:participants)
    expect(relation.macro).to eq :has_and_belongs_to_many
  end

  it 'should know if it is for single players' do
    single_player_event = FactoryBot.build :event, :single_player
    expect(single_player_event).to be_single
  end

  it 'should know if its deadline has passed' do
    passed_deadline_event = FactoryBot.build :event, :passed_deadline
    expect(passed_deadline_event.deadline_has_passed?).to be true
  end

  it "generate_Schedule? should raise a NotImplementedError" do
    event = FactoryBot.build :event
    expect { event.generate_schedule }.to raise_error NotImplementedError
  end

  it "should have the attributes min and max players per team" do
    expect(event).to be_valid
    event.min_players_per_team = nil
    event.max_players_per_team = nil
    expect(event).not_to be_valid
  end

  it "min players per team = max players per team = 1 if it is a single player event" do
    single_player_event = FactoryBot.build :event, :single_player
    expect(single_player_event.min_players_per_team).to eq(1)
    expect(single_player_event.max_players_per_team).to eq(1)
  end

  it "should not be possible, that the min playercount per team is higher than the max playercount" do
    team_event = FactoryBot.build :event, :with_teams
    team_event.min_players_per_team = 15
    team_event.max_players_per_team = 11
    expect(team_event).not_to be_valid
  end

  context "with team event" do
    before :each do
      @team_event = FactoryBot.create :event, :with_teams
      @team = FactoryBot.create :team, :with_five_members
      @user = FactoryBot.create :user
      @team.owners << @user
    end

    it "should be possible to join a team event if min/max players per team fits to team size" do
      @team_event.min_players_per_team = 6
      @team_event.max_players_per_team = 6

      expect(@team_event.fitting_teams(@user).count).to be(1)
    end

    it "should be possible to join a team event if min/max players per team fits to team size" do
      @team_event.min_players_per_team = 7
      @team_event.max_players_per_team = 7

      expect(@team_event.fitting_teams(@user).count).to be(0)
    end

    it "should be possible to join a team event if min/max players per team fits to team size" do
      @team_event.min_players_per_team = 5
      @team_event.max_players_per_team = 5

      expect(@team_event.fitting_teams(@user).count).to be(0)
    end
  end
end
