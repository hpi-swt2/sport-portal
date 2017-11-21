class AddEnddateAndDurationToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :enddate, :date
  end
end
