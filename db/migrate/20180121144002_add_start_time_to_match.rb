class AddStartTimeToMatch < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :start_time, :datetime, default: DateTime.now
  end
end
