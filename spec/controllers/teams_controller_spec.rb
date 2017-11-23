require 'rails_helper'

# There are no expectations of assigns and templates rendered in this spec.
# These features have been removed from Rails core in Rails 5, but can be
# added back in via the `rails-controller-testing` gem.

RSpec.describe TeamsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Team. As you add validations to Team, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    FactoryBot.build(:team).attributes
  }

  let(:invalid_attributes) {
    FactoryBot.build(:team, name: '').attributes
  }

  before(:each) do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:admin)
    #sign_in @user
  end

  after(:each) do
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
    sign_in @user
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
      sign_in @user
      team = Team.create! valid_attributes
      get :show, params: {id: team.to_param}
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a unauthorized response" do
      get :new, params: {}
      expect(response).to be_unauthorized
    end

    it "should allow normal user to view page" do
      sign_in @user
      get :new, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a unauthorized response" do
      team = Team.create! valid_attributes
      get :edit, params: { id: team.to_param }
      expect(response).to be_unauthorized
    end

    it "should allow normal user to edit his created team" do
      sign_in @user
      team = Team.create(creator: @user, name: "generic name")
      get :edit, params: {id: team.to_param}
      expect(response).to be_success
    end

    it "should not allow normal user to edit others created team" do
      sign_in @user
      team = Team.create(creator: @other_user, name: "generic name")
      get :edit, params: {id: team.to_param}
      expect(response).to be_forbidden
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Team" do
        sign_in @user
        expect {
          post :create, params: { team: valid_attributes }
        }.to change(Team, :count).by(1)
      end

      it "redirects to the created team" do
        sign_in @user
        post :create, params: { team: valid_attributes }
        expect(response).to redirect_to(Team.last)
      end

      it "should allow normal user to create an team" do
        sign_in @user
        post :create, params: {team: valid_attributes}
        expect(response).to redirect_to(Team.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { team: invalid_attributes }
        expect(response).to be_unauthorized
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { "name" => valid_attributes["name"] + "_new" }
      }

      it "updates the requested team" do
        sign_in @user
        team = Team.create(name: 'Test', creator: @user)
        put :update, params: { id: team.to_param, team: new_attributes }
        team.reload
        expect(team.name).to eq(new_attributes["name"])
      end

      it "redirects to the team" do
        sign_in @user
        team = Team.create(name: 'test', creator: @user)
        put :update, params: { id: team.to_param, team: valid_attributes }
        expect(response).to redirect_to(team)
      end

      it "should allow normal user to update his created team" do
        sign_in @user
        team = Team.create(creator: @user, name: "generic name")
        put :update, params: {id: team.to_param, team: valid_attributes}
        expect(response).to redirect_to(team)
      end

      it "should not allow normal user to update others created teams" do
        sign_in @user
        team = Team.create(creator: @other_user, name: "generic name")
        put :update, params: {id: team.to_param, team: valid_attributes}
        expect(response).to_not be_success
      end
    end

    context "with invalid params" do
      it "returns an unauthorized response (i.e. to display the 'edit' template)" do
        team = Team.create! valid_attributes
        put :update, params: { id: team.to_param, team: invalid_attributes }
        expect(response).to be_unauthorized
      end
    end
  end

  describe "DELETE #destroy" do
    it "returns an unauthorized response when not signed in" do
      team = Team.create! valid_attributes
      delete :destroy, params: { id: team.to_param }
      expect(response).to be_unauthorized
      team.destroy
    end

    it "redirects to the teams list" do
      sign_in @user
      team = Team.create(name: 'Test', creator: @user)
      delete :destroy, params: { id: team.to_param }
      expect(response).to redirect_to(teams_url)
    end

    it "should not allow normal user to destroy teams created by others" do
      sign_in @user
      team = Team.create(creator: @other_user, name: "generic name")
      delete :destroy, params: {id: team.to_param}
      expect(response).to be_forbidden
    end

    it "should allow normal user to destroy his created team" do
      sign_in @user
      team = Team.create(creator: @user, name: "generic name")
      delete :destroy, params: {id: team.to_param}
      expect(response).to redirect_to(teams_url)
    end
  end

end
