class RemoveGameModeFromTournament < ActiveRecord::Migration[5.1]
  def change
    remove_index :tournaments, :game_mode
    remove_column :tournaments, :game_mode, :integer
  end
end
