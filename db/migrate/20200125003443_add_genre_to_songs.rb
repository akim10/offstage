class AddGenreToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :genre, :string
  end
end
