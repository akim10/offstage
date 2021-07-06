class AddMoreFieldsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :name, :string
    add_column :users, :artist_name, :string
    add_column :users, :location, :string
    add_column :users, :bio, :text
    add_column :users, :active, :boolean
  end
end
