require 'rails_helper'

# There are no expectations of assigns and templates rendered in this spec.
# These features have been removed from Rails core in Rails 5, but can be
# added back in via the `rails-controller-testing` gem.

RSpec.describe PlayersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Player. As you add validations to Player, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    FactoryBot.build(:player).attributes
  }

  let(:invalid_attributes) {
    FactoryBot.build(:player, first_name: '').attributes
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PlayersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      player = Player.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      player = Player.create! valid_attributes
      get :show, params: {id: player.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      player = Player.create! valid_attributes
      get :edit, params: {id: player.to_param}, session: valid_session
      expect(response).to be_success
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Player" do
        expect {
          post :create, params: {player: valid_attributes}, session: valid_session
        }.to change(Player, :count).by(1)
      end

      it "redirects to the created player" do
        post :create, params: {player: valid_attributes}, session: valid_session
        expect(response).to redirect_to(Player.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {player: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        {"first_name" => valid_attributes["first_name"] + "_new"}
      }

      it "updates the requested player" do
        player = Player.create! valid_attributes
        put :update, params: {id: player.to_param, player: new_attributes}, session: valid_session
        player.reload
        expect(player.first_name).to eq(new_attributes["first_name"])
      end

      it "redirects to the player" do
        player = Player.create! valid_attributes
        put :update, params: {id: player.to_param, player: valid_attributes}, session: valid_session
        expect(response).to redirect_to(player)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        player = Player.create! valid_attributes
        put :update, params: {id: player.to_param, player: invalid_attributes}, session: valid_session
        expect(response).to be_success
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested player" do
      player = Player.create! valid_attributes
      expect {
        delete :destroy, params: {id: player.to_param}, session: valid_session
      }.to change(Player, :count).by(-1)
    end

    it "redirects to the players list" do
      player = Player.create! valid_attributes
      delete :destroy, params: {id: player.to_param}, session: valid_session
      expect(response).to redirect_to(players_url)
    end
  end

end
