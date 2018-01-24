class AddSelectionTypeToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :selection_type, :integer, null: false, default: 0
  end
end
