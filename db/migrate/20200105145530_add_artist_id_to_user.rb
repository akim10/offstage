class AddArtistIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :artist_id, :string
  end
end
