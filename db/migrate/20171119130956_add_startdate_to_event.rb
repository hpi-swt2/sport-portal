class AddStartdateToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :startdate, :date
  end
end
