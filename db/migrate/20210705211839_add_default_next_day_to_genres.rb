class AddDefaultNextDayToGenres < ActiveRecord::Migration[6.0]
  def change
    change_column_default :genres, :next_day, "Monday"
  end
end
