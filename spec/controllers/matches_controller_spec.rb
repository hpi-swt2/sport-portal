require 'rails_helper'

# There are no expectations of assigns and templates rendered in this spec.
# These features have been removed from Rails core in Rails 5, but can be
# added back in via the `rails-controller-testing` gem.

RSpec.describe MatchesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Match. As you add validations to Match, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    FactoryBot.build(:match).attributes
  }

  let(:invalid_attributes) {
    FactoryBot.build(:match, team_home: nil, team_away: nil).attributes
  }

  let(:authorized_attributes) {
    FactoryBot.build(:match, team_home: @team).attributes
  }

  before(:each) do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:admin)
    @team = FactoryBot.create(:team)
    @team.members << @user
    sign_in @user
  end

  describe "GET #show" do
    it "returns a success response" do
      match = Match.create! valid_attributes
      get :show, params: { id: match.to_param }
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "should allow team members to edit a match" do
      match = Match.create! authorized_attributes
      get :edit, params: { id: match.to_param }
      expect(response).to be_success
    end

    it "shouldn't allow other users to edit a match" do
      sign_out @user
      sign_in @other_user
      match = Match.create! authorized_attributes
      get :edit, params: { id: match.to_param }
      expect(response).not_to be_success
    end

    it "should allow admin to edit a match" do
      sign_in @admin
      match = Match.create! authorized_attributes
      get :edit, params: { id: match.to_param }
      expect(response).to be_success
    end
  end

  describe "GET #edit_results" do
    it "should allow team members to edit the results of a match" do
      match = Match.create! authorized_attributes
      get :edit_results, params: { id: match.to_param }
      expect(response).to be_success
    end

    it "shouldn't allow other users to edit the results of a match" do
      sign_out @user
      sign_in @other_user
      match = Match.create! valid_attributes
      get :edit_results, params: { id: match.to_param }
      expect(response).not_to be_success
    end

    it "should allow admin to edit the results of a match" do
      sign_in @admin
      match = Match.create! valid_attributes
      get :edit_results, params: { id: match.to_param }
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Match" do
        expect {
          post :create, params: { match: valid_attributes }
        }.to change(Match, :count).by(1)
      end

      it "redirects to the created match" do
        post :create, params: { match: valid_attributes }
        expect(response).to redirect_to(Match.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { match: invalid_attributes }
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        FactoryBot.build(:match).attributes
      }

      it "updates the requested match" do
        match = Match.create! authorized_attributes
        put :update, params: { id: match.to_param, match: new_attributes }
        match.reload
        expect(match.place).to eq(new_attributes["place"])
      end

      it "redirects to the match" do
        match = Match.create! authorized_attributes
        put :update, params: { id: match.to_param, match: valid_attributes }
        expect(response).to redirect_to(match)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        match = Match.create! authorized_attributes
        put :update, params: { id: match.to_param, match: invalid_attributes }
        expect(response).to be_success
      end
    end

    context "with unauthorized user" do
      it "shouldn't allow unauthorized user to update" do
        sign_out @user
        sign_in @other_user
        match = Match.create! valid_attributes
        put :update, params: { id: match.to_param, match: valid_attributes }
        expect(response).not_to be_success
      end
    end
  end

  describe "PUT #update_points" do
    context "with valid params" do
      let(:new_attributes) {
        {
          "points_home" => 1,
          "points_away" => 3,
        }
      }

      it "updated the requested match" do
        match = Match.create! valid_attributes
        put :update_points, params: { id: match.to_param, match: new_attributes }
        match.reload
        expect(match.points_home).to eq(new_attributes["points_home"])
        expect(match.points_away).to eq(new_attributes["points_away"])
      end

      it "redirects to its schedule" do
        match = Match.create! valid_attributes
        put :update_points, params: { id: match.to_param, match: valid_attributes }
        expect(response).to redirect_to(event_schedule_url(match.event))
      end
    end

    context "with invalid params" do
      let(:invalid_attributes) {
        {
            "points_home" => "potato",
            "points_away" => "trololol",
        }
      }

      it "redirect to its schedule" do
        match = Match.create! valid_attributes
        put :update_points, params: { id: match.to_param, match: invalid_attributes }
        expect(response).to redirect_to(event_schedule_url(match.event))
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested match" do
      match = Match.create! valid_attributes
      expect {
        delete :destroy, params: { id: match.to_param }
      }.to change(Match, :count).by(-1)
    end

    it "redirects to the event schedule page" do
      match = Match.create! valid_attributes
      delete :destroy, params: { id: match.to_param }
      expect(response).to redirect_to(event_schedule_url(match.event))
    end
  end

  describe "GET #add_game_result" do
    context "with a valid match" do
      let(:match) { FactoryBot.create(:match) }

      it "adds a game result to the match" do
        expect {
          get :add_game_result, params: { id: match.id }
        }.to change(Match, :count).by(1)
      end

      it "returns a success response" do
        get :add_game_result, params: { id: match.id }
        expect(response).to be_success
      end
    end
  end

  describe "GET #remove_game_result" do
    context "with valid params" do
      let(:match) { FactoryBot.create(:match, :with_results, result_count: 1) }

      it "deletes the game result" do
        get :remove_game_result, params: { id: match.id, result_id: match.game_results.first.id }
        match.reload
        expect(match.game_results).to be_empty
      end

      it "returns a success response" do
        get :remove_game_result, params: { id: match.id, result_id: match.game_results.first.id }
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update_results" do

    let(:match) { Match.create! authorized_attributes }
    context "with valid params" do
      let(:new_attributes) {
        {
          "0" => {
            "score_home" => 11,
            "score_away" => 33,
            "id" => ""
          }
        }
      }

      it "updates the requested match" do
        put :update_results, params: { id: match.to_param, match: { game_results_attributes: new_attributes } }
        match.reload
        result = match.game_results.first
        expect(result.score_home).to eq(new_attributes["0"]["score_home"])
        expect(result.score_away).to eq(new_attributes["0"]["score_away"])
        expect(match.scores_proposed_by).to eq(@user)
      end

      it "redirects to the show match page" do
        put :update_results, params: { id: match.to_param, match: { game_results_attributes: new_attributes } }
        expect(response).to redirect_to(match_path(match))
      end
    end
    context "with invalid params" do
      let(:new_attributes) {
        {
            "0" => {
                "score_home" => 'asdf',
                "score_away" => 'dddd',
                "id" => ""
            }
        }
      }

      it "redirects to the edit results page" do
        put :update_results, params: { id: match.to_param, match: { game_results_attributes: new_attributes } }
        expect(response).to render_template :edit_results
      end
    end
  end

  describe "GET #confirm_scores" do
    let(:match) { FactoryBot.create(:match, :with_results, :not_confirmed) }

    context "user can confirm" do
      before(:each) do
        allow_any_instance_of(Match).to receive(:can_confirm_scores?).and_return(true)
      end

      it "should confirm the scores" do
        expect {
          post :confirm_scores, params: { id: match.to_param }
          match.reload
        }.to change { match.scores_confirmed? }.from(false).to(true)
      end

      it "redirects to the edit results page" do
        post :confirm_scores, params: { id: match.to_param  }
        expect(response).to redirect_to edit_results_match_path(match)
      end
    end

    context "user cannot confirm" do
      before(:each) do
        allow_any_instance_of(Match).to receive(:can_confirm_scores?).and_return(false)
      end

      it "should not confirm the game result" do
        expect {
          post :confirm_scores, params: { id: match.to_param }
          match.reload
        }.not_to change { match.scores_confirmed? }
      end

      it "redirects to the edit results page" do
        post :confirm_scores, params: { id: match.to_param }
        expect(response).to be_forbidden
      end
    end
  end
end
