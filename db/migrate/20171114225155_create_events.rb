class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :discipline
      t.integer :player_type
      t.integer :max_teams

      t.timestamps
    end
    add_index :events, :player_type
  end
end
