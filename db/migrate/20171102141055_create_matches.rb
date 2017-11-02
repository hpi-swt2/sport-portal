class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.date :date
      t.string :place
      t.references :team_home, foreign_key: true
      t.references :team_away, foreign_key: true
      t.integer :score_home
      t.integer :score_away

      t.timestamps
    end
  end
end
