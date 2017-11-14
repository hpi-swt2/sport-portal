class CreateTournaments < ActiveRecord::Migration[5.1]
  def change
    create_table :tournaments do |t|
      t.integer :game_mode

      t.timestamps
    end
    add_index :tournaments, :game_mode
  end
end
