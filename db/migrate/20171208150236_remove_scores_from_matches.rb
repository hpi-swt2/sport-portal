class RemoveScoresFromMatches < ActiveRecord::Migration[5.1]
  def change
    remove_column :matches, :score_home, :integer
    remove_column :matches, :score_away, :integer
  end
end
