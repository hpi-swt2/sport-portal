class RemoveDateFromMatches < ActiveRecord::Migration[5.1]
  def change
    remove_column :matches, :date, :date
  end
end
