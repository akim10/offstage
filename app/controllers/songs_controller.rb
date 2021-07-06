class SongsController < ApplicationController

  def index
    if !(params[:search]).blank?
      @track_results = RSpotify::Track.search(params[:search], limit: 15)
    end
    @song = Song.new
  end

  def new
    if current_user.song
      if current_user.song.genre.state == 'in progress'
        redirect_to root_path
      end
    end
    @song = Song.new
    # @artist = RSpotify::Artist.find(current_user.artist_id)
    # @display_name = RSpotify::User.new(current_user.spotify).display_name
    if defined?(current_user.song)
      @old_song = current_user.song
    end
  end

  def create
    @song = Song.new(song_params)
    @song.user_id = current_user.id
    @song.genre_id = current_user.genre_id
    if current_user.song
      current_user.song.delete
    end
    if @song.save
      redirect_to root_path
    else
      redirect_to(root_path, :notice => @song.errors.messages[:song][0])
    end
  end

  def destroy
    if current_user.song.genre.state == 'in progress'
      redirect_to root_path
    else
      @song = current_user.song
      current_user.update_attribute('song', nil)
      @song.destroy
      redirect_to root_path
    end
  end


  def voting
    current_genre = current_user.genre
    @display_name = RSpotify::User.new(current_user.spotify).display_name
    @next_round = get_round_title(current_genre)
    current_pair_id = current_user.song_queue[current_genre.name][0]

    current_pair = current_genre.songs.active.where(pair_id: current_pair_id)
    @song1 = RSpotify::Track.find(current_pair[0].track_id)
    @song2 = RSpotify::Track.find(current_pair[1].track_id)
    @artist1 = RSpotify::Artist.find(@song1.artists[0].id)
    @artist2 = RSpotify::Artist.find(@song2.artists[0].id)

    if current_user.song.present?
      @song = RSpotify::Track.find(current_user.song.track_id)
    end
    if current_user.artist_id?
      @artist = RSpotify::Artist.find(current_user.artist_id)
    end
  end

  def submit_vote
    @voted_song_id = params[:song_id]
    @voted_song = Song.active.where(track_id: @voted_song_id).first
    @voted_song.update_attribute('votes', @voted_song.votes + 1)

    updated_songs_voted = current_user.songs_voted += [@voted_song.id]
    current_user.update_attribute('songs_voted', updated_songs_voted)

    current_genre = current_user.genre

    new_song_queue = current_user.song_queue
    new_song_queue[current_genre.name] = new_song_queue[current_genre.name] -= [@voted_song.pair_id] # could also be -= [current_users.songs_to_vote[0]]

    current_user.update_attribute('song_queue', new_song_queue)
    if current_user.song_queue[current_genre.name].empty?
      redirect_to root_path
    else
      redirect_to voting_songs_url
    end
  end

  private
  def song_params
    params.require(:song).permit(:track_id)
  end
  def get_round_title(genre)
    songs_left = genre.songs.active.count
    if songs_left == 8
      return "Quarterfinals"
    elsif songs_left == 4
      return "Semifinals"
    elsif songs_left == 2
      return "Finals"
    else
      return "Round #{genre.round}"
    end
  end
end