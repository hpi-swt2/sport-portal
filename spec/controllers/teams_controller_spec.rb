require 'rails_helper'

# There are no expectations of assigns and templates rendered in this spec.
# These features have been removed from Rails core in Rails 5, but can be
# added back in via the `rails-controller-testing` gem.

RSpec.describe TeamsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Team. As you add validations to Team, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    FactoryBot.attributes_for(:team)
  }

  let(:invalid_attributes) {
    FactoryBot.build(:team, name: '').attributes
  }

  before(:each) do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:admin)
    sign_in @user
  end

  after(:each) do
    Team.delete_all
    @user.destroy
    @other_user.destroy
    @admin.destroy
  end

  describe "GET #index" do
  it "returns a success response" do
    team = Team.create! valid_attributes
    get :index, params: {}
    expect(response).to be_success
  end

  it "should allow normal user to view page" do
    get :index, params: {}
    expect(response).to be_success
  end
end

  describe "GET #show" do
    it "returns a success response" do
      team = Team.create! valid_attributes
      get :show, params: { id: team.to_param }
      expect(response).to be_success
    end

    it "should allow normal user to view page" do
      team = Team.create! valid_attributes
      get :show, params: { id: team.to_param }
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a unauthorized response" do
      sign_out @user
      get :new, params: {}
      expect(response).to be_unauthorized
    end

    it "should allow normal user to view page" do
      get :new, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a unauthorized response" do
      sign_out @user
      team = Team.create! valid_attributes
      get :edit, params: { id: team.to_param }
      expect(response).to be_unauthorized
    end

    it "returns a success response if the user is a member" do
      team = Team.create! valid_attributes
      team.members << subject.current_user
      get :edit, params: { id: team.to_param }
      expect(response).to be_success
    end

    it "should allow normal user to edit his created team" do
      team = Team.create! valid_attributes
      team.owners << subject.current_user
      team.members << subject.current_user
      get :edit, params: { id: team.to_param }
      expect(response).to be_success
    end

    it "should not allow normal user to edit others created team" do
      sign_in @other_user
      team = Team.create! valid_attributes
      get :edit, params: { id: team.to_param }
      expect(response).to be_forbidden
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Team" do
        expect {
          post :create, params: { team: valid_attributes }
        }.to change(Team, :count).by(1)
      end

      it "creates a new TeamOwner" do
        expect {
          post :create, params: { team: valid_attributes }
        }.to change(TeamOwner, :count).by(1)
      end

      it "creates a new TeamMember" do
        expect {
          post :create, params: { team: valid_attributes }
        }.to change(TeamMember, :count).by(1)
      end

      it "redirects to the created team" do
        post :create, params: { team: valid_attributes }
        expect(response).to redirect_to(Team.last)
      end

      it "should allow normal user to create an team" do
        post :create, params: { team: valid_attributes }
        expect(response).to redirect_to(Team.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { team: invalid_attributes }
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { :name => valid_attributes[:name] + "_new" }
      }

      it "updates the requested team" do
        team = Team.create! valid_attributes
        team.members << subject.current_user
        put :update, params: { id: team.to_param, team: new_attributes }
        team.reload
        expect(team.name).to eq(new_attributes[:name])
      end

      it "redirects to the team" do
        team = Team.create! valid_attributes
        team.members << subject.current_user
        put :update, params: { id: team.to_param, team: valid_attributes }
        expect(response).to redirect_to(team)
      end

      it "should allow normal user to update his created team" do
        team = Team.create! valid_attributes
        team.owners << subject.current_user
        team.members << subject.current_user
        put :update, params: { id: team.to_param, team: valid_attributes }
        expect(response).to redirect_to(team)
      end

      it "should not allow normal user to update others created teams" do
        sign_in @other_user
        team = Team.create! valid_attributes
        put :update, params: { id: team.to_param, team: valid_attributes }
        expect(response).to_not be_success
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        team = Team.create! valid_attributes
        team.members << subject.current_user
        put :update, params: { id: team.to_param, team: invalid_attributes }
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "returns an unauthorized response when not signed in" do
      sign_out @user
      team = Team.create! valid_attributes
      delete :destroy, params: { id: team.to_param }
      expect(response).to be_unauthorized
      team.destroy
    end

    it "deletes the associated team ownerships and team memberships" do
      team = Team.create! valid_attributes
      team.owners << subject.current_user
      team.members = team.members + team.owners
      expect {
        delete :destroy, params: { id: team.to_param }
      }.to change(TeamOwner, :count).by(-1)
        .and change(TeamMember, :count).by(-1)
    end

    it "redirects to the teams list" do
      team = Team.create! valid_attributes
      team.owners << subject.current_user
      delete :destroy, params: { id: team.to_param }
      expect(response).to redirect_to(teams_url)
    end

    it "should not allow normal user to destroy teams created by others" do
      sign_in @other_user
      team = Team.create! valid_attributes
      delete :destroy, params: { id: team.to_param }
      expect(response).to be_forbidden
    end

    it "should allow normal user to destroy his created team" do
      team = Team.create! valid_attributes
      team.owners << subject.current_user
      delete :destroy, params: { id: team.to_param }
      expect(response).to redirect_to(teams_url)
    end
  end

  describe 'POST #assign_ownership' do
    it 'succeeds when called as a team owner' do
      team = Team.create! valid_attributes
      team.owners << subject.current_user
      team.members = team.members + team.owners
      anotherUser = FactoryBot.create :user

      expect {
        post :assign_ownership, params: { id: team.id, team_member: anotherUser.id }
      }.to change(TeamOwner, :count).by(1)
    end


    it 'fails when when not called as a team owner' do
      team = Team.create! valid_attributes
      anotherUser = FactoryBot.create :user

      post :assign_ownership, params: { id: team.id, team_member: anotherUser.id }
      expect(response).to be_forbidden
    end

    it 'should not add a team owner twice' do
      team = Team.create! valid_attributes
      team.owners << subject.current_user
      team.members = team.members + team.owners
      anotherUser = FactoryBot.create :user

      post :assign_ownership, params: { id: team.id, team_member: anotherUser.id }

      expect {
        post :assign_ownership, params: { id: team.id, team_member: anotherUser.id }
      }.to change(TeamOwner, :count).by(0)
    end
  end

  describe 'POST #delete_ownership' do
    it 'succeeds when called as a team owner' do
      team = Team.create! valid_attributes
      anotherUser = FactoryBot.create :user

      team.owners << subject.current_user
      team.owners << anotherUser

      team.members = team.members + team.owners

      expect {
        post :delete_ownership, params: { id: team.id, team_member: anotherUser.id }
      }.to change(TeamOwner, :count).by(-1)
    end

    it 'does not succeed when called as a team meber' do
      team = Team.create! valid_attributes
      anotherUser = FactoryBot.create :user

      team.owners << anotherUser

      team.members = team.members + team.owners

      post :delete_ownership, params: { id: team.id, team_member: anotherUser.id }
      expect(response).to be_forbidden
    end
  end

  describe 'POST #delete_membership' do
    it 'succeeds when called as a team owner' do
      team = Team.create! valid_attributes
      anotherUser = FactoryBot.create :user

      team.owners << subject.current_user
      team.owners << anotherUser

      team.members = team.members + team.owners

      expect {
        post :delete_membership, params: { id: team.id, team_member: anotherUser.id }
      }.to change(TeamMember, :count).by(-1)
    end
  end
end
