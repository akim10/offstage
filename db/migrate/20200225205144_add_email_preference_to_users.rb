class AddEmailPreferenceToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :email_preference, :string, default: "round"
  end
end
