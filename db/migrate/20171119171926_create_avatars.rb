class CreateAvatars < ActiveRecord::Migration[5.1]
  def change
	create_table :avatars do |t|
	  t.text :image_data
	  t.string :user_id
	  t.timestamps
	end
  end
end
