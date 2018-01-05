class CreateMatchResults < ActiveRecord::Migration[5.1]
  def change
    create_table :match_results do |t|
      t.references :match
      t.boolean :winner_advances

      t.timestamps
    end
  end
end
