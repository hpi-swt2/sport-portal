class CreateMatches < ActiveRecord::Migration[5.0]
  def change
    create_table :matches do |t|
      t.date :date
      t.string :place
      t.integer :score_home
      t.integer :score_away

      t.timestamps
    end

    add_column :matches, :team_home, :integer, index: true
    add_column :matches, :team_away, :integer, index: true
  end
end
