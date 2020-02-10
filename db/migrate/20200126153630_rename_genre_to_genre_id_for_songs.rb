class RenameGenreToGenreIdForSongs < ActiveRecord::Migration[6.0]
  def change
    rename_column :songs, :genre, :genre_id
    change_column :songs, :genre_id, :integer, using: 'genre_id::integer'
  end
end
