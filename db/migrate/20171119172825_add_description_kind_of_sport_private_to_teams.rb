class AddDescriptionKindofsportPrivateToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :description, :text
    add_column :teams, :kind_of_sport, :string
    add_column :teams, :private, :boolean
  end
end
