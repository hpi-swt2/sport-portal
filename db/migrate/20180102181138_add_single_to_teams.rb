class AddSingleToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :single, :boolean, default: false
  end
end
