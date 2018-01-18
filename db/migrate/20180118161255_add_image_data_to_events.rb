class AddAvatarDataToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :image_data, :text
  end
end
