class AddPlace3OptionalFlag < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :has_place_3_match, :boolean, default: true
  end
end
