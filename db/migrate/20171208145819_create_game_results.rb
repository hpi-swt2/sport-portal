class CreateGameResults < ActiveRecord::Migration[5.1]
  def change
    create_table :game_results do |t|
      t.integer :score_home
      t.integer :score_away
      t.references :match, foreign_key: true

      t.timestamps
    end
  end
end
