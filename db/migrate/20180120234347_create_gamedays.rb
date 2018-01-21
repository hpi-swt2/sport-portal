class CreateGamedays < ActiveRecord::Migration[5.1]
  def change
    create_table :gamedays do |t|
      t.string :description
      t.datetime :starttime
      t.datetime :endtime
      t.references :event, foreign_key: true

      t.timestamps
    end
  end
end
