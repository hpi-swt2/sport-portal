class AddMinMaxPlayersPerTeamToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :min_players_per_team, :integer
    add_column :events, :max_players_per_team, :integer
  end
end
