class Song < ApplicationRecord
  belongs_to :user, optional: true #, foreign_key: "user_id"
  belongs_to :genre
  validates :user_id, uniqueness: true
  validates :track_id, uniqueness: true
  validates_presence_of :user
  validates_presence_of :genre
  validate :validate_max_participants

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  private
  def validate_max_participants
    if Song.where(genre_id: self.genre_id).count >= 0
      if errors.blank?
        errors.add(:song, "Reached participant cap for this genre.")
        return false
      end
    end
  end

end