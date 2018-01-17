class MakeKoDefaultTournamentMode < ActiveRecord::Migration[5.1]
  def up
    change_column :events, :game_mode, :integer, default: 0, null: false
  end
  def down
  end
end
