require "rails_helper"

RSpec.describe LeaguesController, type: :routing do
  describe "routing" do
    it 'routes to #ranking' do
      expect(get: "/leagues/1/ranking").to route_to("leagues#ranking", id: "1")
    end
  end
end
