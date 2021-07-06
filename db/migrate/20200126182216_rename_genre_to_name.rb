class RenameGenreToName < ActiveRecord::Migration[6.0]
  def change
    rename_column :genres, :genre, :name
  end
end
