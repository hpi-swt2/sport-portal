class RemoveGameModeFromLeague < ActiveRecord::Migration[5.1]
  def change
    remove_index :leagues, :game_mode
    remove_column :leagues, :game_mode, :integer
  end
end
