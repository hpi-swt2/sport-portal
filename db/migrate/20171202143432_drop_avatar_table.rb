class DropAvatarTable < ActiveRecord::Migration[5.1]
  def change
  	drop_table :avatars
  end
end
