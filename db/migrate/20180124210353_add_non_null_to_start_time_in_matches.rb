class AddNonNullToStartTimeInMatches < ActiveRecord::Migration[5.1]
  def change
    change_column :matches, :start_time, :datetime, null: false
  end
end
