class Song < ApplicationRecord
  belongs_to :user, optional: true #, foreign_key: "user_id"
  belongs_to :genre
  validates :user_id, uniqueness: true
  validates :track_id, uniqueness: true
  validates_presence_of :user
  validates_presence_of :genre
  before_create :validate_max_participants

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

  private
  def validate_max_participants
    errors.add("Reached participant cap.") if Song.count == 32
  end

end