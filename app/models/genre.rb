class Genre < ApplicationRecord
  has_many :songs
  has_many :users

  def format_genre
    if self.id == 1
      return "Hip Hop"
    elsif self.id == 2
      return "Electronic"
    elsif self.id == 3
      return "Rock"
    elsif self.id == 4
      return "Indie"
    end
  end

end
