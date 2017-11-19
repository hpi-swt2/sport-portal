class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.string :gamemode
      t.string :sport
      t.boolean :teamsport
      t.integer :playercount
      t.text :gamesystem
      t.date :deadline

      t.timestamps
    end
  end
end
