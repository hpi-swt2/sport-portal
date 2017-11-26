class AddUniqueOmniauthToUsers < ActiveRecord::Migration[5.1]
  def change
    add_index :users, [:provider, :uid], unique: true
  end
end
