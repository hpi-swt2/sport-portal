# as seen here: https://github.com/plataformatec/devise/wiki/How-To:-Add-:confirmable-to-Users
class AddUnconfirmedEmail < ActiveRecord::Migration[5.1]
  def change
    change_table :users do |t|
      t.string :confirmation_token, :unconfirmed_email
      t.datetime :confirmed_at, :confirmation_sent_at
      t.index :confirmation_token, unique: true
    end

    reversible do |dir|
      dir.up do
        say_with_time 'Confirming all existing users' do
          User.all.update_all confirmed_at: DateTime.now
        end
      end
    end
  end
end
