class AddGenreToWinners < ActiveRecord::Migration[6.0]
  def change
    add_column :winners, :genre, :string
  end
end
