class MakeKoDefaultTournamentMode < ActiveRecord::Migration[5.1]
  def change
    change_column :events, :game_mode, :integer, default: 0, null: false
  end
end
