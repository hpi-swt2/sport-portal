class AddPointsHomePointsAwayToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :points_home, :integer
    add_column :matches, :points_away, :integer
  end
end
