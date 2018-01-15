class AddMatchIndex < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :index, :int, default: nil, null: true
  end
end
