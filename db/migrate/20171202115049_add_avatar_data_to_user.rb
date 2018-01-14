class AddAvatarDataToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :avatar_data, :text
  end
end
