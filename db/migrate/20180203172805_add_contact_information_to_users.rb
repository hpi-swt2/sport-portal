class AddContactInformationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :contact_information, :string
  end
end
