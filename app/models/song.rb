class Song < ApplicationRecord
  belongs_to :user, optional: true #, foreign_key: "user_id"
  belongs_to :genre
  # validates :user_id, uniqueness: true
  validates :track_id, uniqueness: true
  # validates_presence_of :user
  validates_presence_of :genre
  validate :validate_max_participants
  validate :is_under_follower_limit

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  private
  def validate_max_participants
    if Song.where(genre_id: self.genre_id).count >= 32
      if errors.blank?
        errors.add(:song, "Reached participant cap for this genre.")
        return false
      end
    end
  end

  # def validate_not_winner
  #   if Winner.all.include?(self)
  #     if errors.blank?
  #       errors.add(:song, "This song has won a bracket already.")
  #       return false
  #     end
  #   end
  # end

  def is_under_follower_limit
    if errors.blank?
      song = RSpotify::Track.find(self.track_id)
      artist = RSpotify::Artist.find(song.artists[0].id)
      if (artist.followers["total"] > 25000)
        errors.clear
        errors.add(:song, 'Artist cannot have more than 25,000 followers.')
      end
    end
  end

end