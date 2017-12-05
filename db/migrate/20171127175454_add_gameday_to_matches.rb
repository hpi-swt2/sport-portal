class AddGamedayToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :gameday, :integer
  end
end
