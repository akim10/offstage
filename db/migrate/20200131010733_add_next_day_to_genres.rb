class AddNextDayToGenres < ActiveRecord::Migration[6.0]
  def change
    add_column :genres, :next_day, :string, default: "Sunday"
  end
end
