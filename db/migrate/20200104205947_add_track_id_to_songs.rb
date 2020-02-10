class AddTrackIdToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :track_id, :string
  end
end
