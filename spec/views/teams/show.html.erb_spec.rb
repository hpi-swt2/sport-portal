require 'rails_helper'

RSpec.describe "teams/show", type: :view do
  before(:each) do
    @team = assign(:team, FactoryBot.create(:team))
    @user = FactoryBot.build :user
    FactoryBot.build(:user)
  end

  it "renders attributes" do
    render
    expect(rendered).to have_content(@team.name, count: 1)
    expect(rendered).to have_content(@team.kind_of_sport, count: 1)
    expect(rendered).to have_content(@team.description, count: 1)
  end

  it "does not show delete ownership button for mere members" do
    user = FactoryBot.create :user
    @team.owners = []
    render
    rendered.should_not have_content(t("helpers.links.delete_ownership"))
  end

  it "shows delete ownership button for owners" do
    @team.owners << @user
    another_user = FactoryBot.create :user
    @team.owners << another_user
    sign_in @user
    render
    rendered.should have_content(t("helpers.links.delete_ownership"))
  end

  it "shows the leave button when user can leave team" do
    another_user = FactoryBot.create :user
    @team.owners << another_user
    @team.members << @user
    # User has team membership, therefore able to delete his membership, according to ability :delete_membership
    sign_in @user
    render
    expect(rendered).to have_selector(:link_or_button, t('helpers.links.leave_team'))
  end

  it "does not show assign ownership button for owners" do
    user = FactoryBot.create :user
    @team.members << @user
    @team.owners = @team.members
    render
    rendered.should_not have_content(t("helpers.links.assign_ownership"))
  end

  describe 'invite user to team' do
    before(:each) do
      @user = FactoryBot.create :user
      sign_in @user
    end

    describe 'button' do
      it 'should be rendered for team members' do
        @team.members << @user
        render
        expect(rendered).to have_selector(:link_or_button, t('teams.show.invite_user_to_team'))
      end

      it 'should not be rendered for users that are not members of the team' do
        render
        expect(rendered).to_not have_selector(:link_or_button, t('teams.show.invite_user_to_team'))
      end
    end

    describe 'modal' do
      it 'should be rendered for team members' do
        @team.members << @user
        render
        expect(rendered).to have_selector('#invite_user_by_email_modal')
        expect(rendered).to have_content(t('teams.invite_user_to_team.title'))
        expect(rendered).to have_field(User.human_attribute_name(:email))
        expect(rendered).to have_selector(:link_or_button, t('helpers.links.cancel'))
        expect(rendered).to have_selector(:link_or_button, t('helpers.links.send'))
      end

      it 'should not be rendered for users that are not members of the team' do
        render
        expect(rendered).to_not have_selector('#invite_user_by_email_modal')
      end
    end
  end



  it "doesn't render the edit button when not signed in" do
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.edit'))
  end

  it "doesn't render the delete button when not signed in" do
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.destroy'))
  end

  it "doesn't render the edit button when it's not your team" do
    sign_in @user
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.edit'))
  end

  it "doesn't render the delete button when it's not your team" do
    sign_in @user
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.destroy'))
  end

  it "doesn't render the delete membership button for current user" do
    @team.owners = [@user]
    @team.members = @team.owners
    sign_in @user
    render
    # Current user is the one and only owner/member of current team
    expect(rendered).to_not have_content(t('helpers.links.delete_membership'))
  end

  it "doesn't render the leave button when user is not allowed to leave team" do
    another_user = FactoryBot.build :user
    @team.owners << another_user
    # User has no team membership, therefore unable to delete his membership, according to ability :delete_membership
    sign_in @user
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.leave_team'))
  end

  it "doesn't render the leave button when user has no team membership" do
    sign_in @user
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.leave_team'))
  end
end
