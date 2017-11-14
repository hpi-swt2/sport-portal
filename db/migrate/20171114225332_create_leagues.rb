class CreateLeagues < ActiveRecord::Migration[5.1]
  def change
    create_table :leagues do |t|
      t.integer :game_mode

      t.timestamps
    end
    add_index :leagues, :game_mode
  end
end
