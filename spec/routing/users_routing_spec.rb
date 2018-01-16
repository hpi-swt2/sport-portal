require "rails_helper"

RSpec.describe UsersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "/users").to route_to("users#index")
    end

    it "routes to #show" do
      expect(get: "/users/1").to route_to("users#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/users/1/edit").to route_to("users#edit", id: "1")
    end

    it "routes to #dashboard" do
      expect(get: "/users/1/dashboard").to route_to("users#dashboard", id: "1")
    end

    it "routes to #notifications" do
      expect(get: "/users/1/notifications").to route_to("users#notifications", id: "1")
    end

    it "routes to #sign_up to #new" do
      expect(get: "/my/users/sign_up").to route_to("users#new")
    end

    it "routes to #update via PUT" do
      expect(put: "/users/1").to route_to("users#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/users/1").to route_to("users#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/users/1").to route_to("users#destroy", id: "1")
    end

    it "routes to #edit_profile" do
      expect(get: "/users/1/profile/edit").to route_to("users#edit_profile", id: "1")
    end

    it "routes to #update_profile via PUT" do
      expect(put: "/users/1/profile").to route_to("users#update_profile", id: "1")
    end

    it "routes to #update_profile via PATCH" do
      expect(patch: "/users/1/profile").to route_to("users#update_profile", id: "1")
    end

  end
end
