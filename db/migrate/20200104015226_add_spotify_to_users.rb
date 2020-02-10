class AddSpotifyToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :spotify, :json
  end
end
