class AddGamedayDurationToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :gameday_duration, :integer
  end
end
