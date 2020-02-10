class AddNotificationToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :notification, :string
  end
end
