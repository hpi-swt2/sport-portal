class ChangeGameModeAndPlayerTypesNull < ActiveRecord::Migration[5.1]
  def change
    change_column :events, :player_type, :integer, :null => true
    change_column :events, :game_mode, :integer, :null => true
  end
end
