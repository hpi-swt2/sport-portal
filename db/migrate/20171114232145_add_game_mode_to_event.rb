class AddGameModeToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :game_mode, :integer
    add_index :events, :game_mode
  end
end
