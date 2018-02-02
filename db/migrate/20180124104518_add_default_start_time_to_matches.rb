class AddDefaultStartTimeToMatches < ActiveRecord::Migration[5.1]
  def up
    change_column_default :matches, :start_time, -> { 'CURRENT_TIMESTAMP' }
  end
  def down
    change_column :matches, :start_time, :datetime, default: nil
  end
end
