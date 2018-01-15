class AddAvatarDataToTeams < ActiveRecord::Migration[5.1]
  def change
    add_column :teams, :avatar_data, :text
  end
end
