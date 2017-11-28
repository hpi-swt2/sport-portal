class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :discipline
      t.integer :player_type, null: false
      t.integer :max_teams
      t.integer :game_mode, null: false
      t.string :type

      t.timestamps
    end
    add_index :events, :player_type
    add_index :events, :game_mode
  end
end
