class User < ApplicationRecord
  has_one :song
  belongs_to :genre, optional: true 

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: %i[spotify]

  validates_presence_of :uid, :provider
  validates :artist_id, format: /\Aspotify:artist:[A-Za-z0-9]{22}\z|\A[A-Za-z0-9]{22}\z/, :allow_blank => true
  validates :artist_id, :uniqueness => {:message => "This artist ID already been taken. If you think this is a mistake, please contact us."}, :allow_nil => true
  # validates_presence_of :genre
  validate :is_real_artist_id
  # validate :is_under_follower_limit
  


  private
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.spotify_data"] && session["devise.spotify_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def is_under_follower_limit
    if errors.blank?
      artist = RSpotify::Artist.find(self.artist_id)
      if (artist.followers["total"] > 100000)
        errors.add(:artist_id, 'Artists cannot have more than 100000 followers.')
      end
    end
  end

  def is_real_artist_id
    artist =  RSpotify::Artist.find((self.artist_id))
    return true
  rescue RestClient::NotFound, RestClient::BadRequest
    errors.clear
    errors.add(:artist_id, "Sorry, we couldn't find that artist, please make sure the Artist URI is valid.")
    return false
  end

end
