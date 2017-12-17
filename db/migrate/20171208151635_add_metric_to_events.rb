class AddMetricToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :initial_value, :float
  end
end
