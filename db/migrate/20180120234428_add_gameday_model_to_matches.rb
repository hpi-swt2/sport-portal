class AddGamedayModelToMatches < ActiveRecord::Migration[5.1]
  def change
    add_reference :matches, :gameday, foreign_key: true
  end
end
