class AddEnddateAndDurationToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :enddate, :date
    add_column :events, :duration, :integer
  end
end
