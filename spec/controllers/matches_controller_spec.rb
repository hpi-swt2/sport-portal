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

  describe "GET #index" do
    it "returns a success response" do
      match = Match.create! valid_attributes
      get :index, params: {}
      expect(response).to be_success
    end
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
    it "returns a success response" do
      match = Match.create! valid_attributes
      get :edit, params: { id: match.to_param }
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
        { "date" => valid_attributes["date"] + 1.day }
      }

      it "updates the requested match" do
        match = Match.create! valid_attributes
        put :update, params: { id: match.to_param, match: new_attributes }
        match.reload
        expect(match.date).to eq(new_attributes["date"])
      end

      it "redirects to the match" do
        match = Match.create! valid_attributes
        put :update, params: { id: match.to_param, match: valid_attributes }
        expect(response).to redirect_to(match)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        match = Match.create! valid_attributes
        put :update, params: { id: match.to_param, match: invalid_attributes }
        expect(response).to be_success
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

    it "redirects to the matches list" do
      match = Match.create! valid_attributes
      delete :destroy, params: { id: match.to_param }
      expect(response).to redirect_to(matches_url)
    end
  end

end
