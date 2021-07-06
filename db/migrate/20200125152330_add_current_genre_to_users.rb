class AddCurrentGenreToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :current_genre, :string
  end
end
