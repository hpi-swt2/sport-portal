class AddAdvancedOptionsToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :matchtype, :integer
    add_column :events, :bestof_length, :integer
    add_column :events, :game_winrule, :integer
    add_column :events, :points_for_win, :integer
    add_column :events, :points_for_draw, :integer
    add_column :events, :points_for_lose, :integer
  end
end
