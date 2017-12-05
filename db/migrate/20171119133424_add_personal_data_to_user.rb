class AddPersonalDataToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :birthday, :date
    add_column :users, :telephone_number, :string
    add_column :users, :telegram_username, :string
    add_column :users, :favourite_sports, :string
  end
end
