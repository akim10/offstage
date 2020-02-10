class RenameCurrentGenreToGenreId < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :current_genre, :genre_id
  end
end
