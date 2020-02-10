class Genre < ApplicationRecord
  has_many :songs
  has_many :users

  def format_genre
    if self.id == 1
      return "Hip Hop"
    elsif self.id == 2
      return "EDM"
    elsif self.id == 3
      return "Pop"
    elsif self.id == 4
      return "Indie"
    end
  end

end
