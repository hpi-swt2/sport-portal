# == Schema Information
#
# Table name: teams
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  description   :text
#  kind_of_sport :string
#  private       :boolean
#  avatar_data   :text
#  single        :boolean          default(FALSE)


require 'rails_helper'

RSpec.describe Team, type: :model do
  it "is valid when produced by a factory" do
    team = FactoryBot.build :team
    expect(team).to be_valid
  end

  it "should have and belong to team owners" do
    team = FactoryBot.create :team
    # After building a team via FactoryBot an owner is created using the factory for users and assigned to the team
    expect(team.owners).to have(1).items
  end

  it "should have and belong to team members" do
    # After building a team via FactoryBot a member is created using the factory for users and assigned to the team
    team = FactoryBot.create :team
    expect(team.members).to have(1).items
  end

  describe '#matches' do
    it 'should return all matches of the team' do
      team = FactoryBot.create(:team)
      expect(team.matches).to be_empty
      match_a = FactoryBot.create(:match)
      match_b = FactoryBot.create(:match)
      match_a.team_home = team
      match_b.team_away = team
      match_a.save
      match_b.save
      team.reload
      expect(team.home_matches).to contain_exactly(match_a)
      expect(team.away_matches).to contain_exactly(match_b)
      expect(team.matches).to contain_exactly(match_a, match_b)
    end
  end

  it "should be able to have multiple team owners" do
    team = FactoryBot.create :team, :with_two_owners
    expect(team.owners).to have(2).items
    expect(team.members).to have(2).items
  end

  it "should be able to have multiple team members" do
    team = FactoryBot.create :team, :with_five_members
    expect(team.members).to have_at_least(5).items
  end

  it "should be in event if an event is assigned" do
    team = FactoryBot.create :team
    expect(team.associated_with_event?).to be false

    event = FactoryBot.create :event
    team.events << event
    expect(team.associated_with_event?).to be true
  end

  it 'is valid with image as avatar' do
    team = FactoryBot.build :team, :with_avatar
    expect(team).to be_valid
  end

  it 'is not valid with any other file type than image' do
    team = FactoryBot.build :team, :with_large_avatar
    expect(team).not_to be_valid
    expect(team.errors[:avatar]).to include(I18n.t('users.avatar.errors.mime_type_inclusion'))
  end

  it 'is not valid with an avatar of size >2mb' do
    team = FactoryBot.build :user, :with_large_avatar
    expect(team).not_to be_valid
    expect(team.errors[:avatar]).to include(I18n.t('users.avatar.errors.max_size'))
  end

  it "by default return teams ordered by their date of creation" do
    team = FactoryBot.create :team
    another_team = FactoryBot.create :team
    # update team name to be able to check that updated_at is not used to order teams
    team.name = "New Name"
    expect(Team.all).to eq([team, another_team])
  end

  it 'should notify newly added team members' do
    team = FactoryBot.create :team

    user = FactoryBot.create :user
    expect { team.members << user }.to change { ActionMailer::Base.deliveries.length }.by(1)
  end

  it 'should not notify newly added team members when team is created by event' do
    team = FactoryBot.create :team, :created_by_event

    user = FactoryBot.create :user
    expect { team.members << user }.to change { ActionMailer::Base.deliveries.length }.by(0)
  end

  it 'should notify its members when it participates in an event' do
    team = FactoryBot.create :team
    user1 = FactoryBot.create :user
    user2 = FactoryBot.create :user
    team.members << [user1, user2]
    team_members_count = team.members.length

    event = FactoryBot.create :event
    expect { event.add_team team }.to change { ActionMailer::Base.deliveries.length }.by(team_members_count)
  end

  it 'should not notify its members when it participates in an event and team is created by event' do
    team = FactoryBot.create :team, :created_by_event

    event = FactoryBot.create :event
    expect { event.add_team team }.to change { ActionMailer::Base.deliveries.length }.by(0)
  end
end
