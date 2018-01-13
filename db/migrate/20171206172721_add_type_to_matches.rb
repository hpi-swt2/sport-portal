class AddTypeToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :team_home_type, :string, default: 'Team'
    add_column :matches, :team_away_type, :string, default: 'Team'
  end
end
