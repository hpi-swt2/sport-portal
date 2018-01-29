class AddDefaultStartTimeToMatches < ActiveRecord::Migration[5.1]
  def change
    change_column_default :matches, :start_time, -> { 'CURRENT_TIMESTAMP' }
  end
end
