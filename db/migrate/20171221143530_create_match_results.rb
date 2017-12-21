class CreateMatchResults < ActiveRecord::Migration[5.1]
  def change
    create_table :match_results do |t|
      t.integer :match_id
      t.boolean :winner

      t.timestamps
    end
  end
end
