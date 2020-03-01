class AddAnnouncementEmailPreferenceToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :announcement_email_preference, :string, default: "announcement"
  end
end