class AddNotificationSettingsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :team_notifications_enabled, :boolean, default: true
    add_column :users, :event_notifications_enabled, :boolean, default: true
  end
end
