class ChangeGamedayToGamedayNumberForMatches < ActiveRecord::Migration[5.1]
  def change
    rename_column :matches, :gameday, :gameday_number
  end
end
