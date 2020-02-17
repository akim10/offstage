namespace :round do


# ------------ Very initial setup, do at launch ------------ #

desc "Initial setup, stage has not started"
  task initial_setup: :environment do
    # Rake::Task["round:create_genres"].invoke
    # Rake::Task["round:fill_songs"].invoke
    genres = [
      { name: 'hiphop', participant_cap: 32 },
      { name: 'edm', participant_cap: 32 },
      { name: 'pop', participant_cap: 32 },
      { name: 'indie', participant_cap: 32 }
    ]
    genres.each { |genre| Genre.create! genre }
  end




# ------------ State: "not started", do these to start the stage ------------ #
  desc "Determining what action to do for each of the genres"
  task determine_action: :environment do
    require 'date'
    # start_date = Date.new(2020,2,28)
    # if Date.today >= start_date
      # if ['Sunday', 'Wednesday'].include? Date.today.strftime("%A")
        Genre.all.each do |genre|
          if genre.state == "in progress"
            puts "state: in progress"
            Rake::Task["round:progress_round"].invoke(genre)
            Rake::Task["round:progress_round"].reenable
          elsif genre.state == "ended"
            puts "state: ended"
            # if Date.today.strftime("%A") == genre.next_day
              Rake::Task["round:start_stage"].invoke(genre)
              Rake::Task["round:start_stage"].reenable
            # end
          elsif genre.state == "not started"
            puts "state: not started"
            Rake::Task["round:start_stage"].invoke(genre)
            Rake::Task["round:start_stage"].reenable
          end
        end
      # end
    # end
  end

  desc "Invoke the set up stage task depending on whether or not byes are needed"
  task :start_stage, [:genre] => [:environment] do |task, args|
    # if the number of entered songs is a power of 2
    puts "in start stage"
    unless args[:genre].songs.count < 2
      if args[:genre].songs.count.to_s(2).count('1') == 1
        Rake::Task["round:set_up_stage"].invoke(args[:genre])
        Rake::Task["round:set_up_stage"].reenable
      else
        Rake::Task["round:set_up_stage_with_byes"].invoke(args[:genre])
        Rake::Task["round:set_up_stage_with_byes"].reenable
      end
      args[:genre].update_attribute("state", "in progress")
    end
    if args[:genre].next_day == "Sunday"
      args[:genre].update_attribute("next_day", "Wednesday")
    elsif args[:genre].next_day == "Wednesday"
      args[:genre].update_attribute("next_day", "Sunday")
    end
  end

  desc "Assign initial random pair_ids to the entered songs and songs_to_vote to users"
  task :set_up_stage, [:genre] => [:environment] do |task, args|
    # Genre.all.each do |genre|
      genre = args[:genre]
      song_total = genre.songs.count
      total_pair_ids = song_total/2
      pair_id_array = (1..total_pair_ids).to_a
      i = 0
      genre.songs.order('RANDOM()').each_slice(2) do |song1, song2|
        song1.update_attribute('pair_id', pair_id_array[i])
        song2.update_attribute('pair_id', pair_id_array[i])
        i = i + 1
      end
      puts "assigned pair_ids"
      User.all.each do |user|
        new_bracket_order = user.bracket_order
        new_bracket_order[genre.name] = pair_id_array.shuffle
        user.update_attribute('song_queue', new_bracket_order)
        user.update_attribute('bracket_order', new_bracket_order)
      end
      puts "assigned songs_to_vote"
    # end
  end

  desc "Assign initial random pair_ids to the entered songs and songs_to_vote to users with byes"
  task :set_up_stage_with_byes, [:genre] => [:environment] do |task, args|
    # Genre.all.each do |genre|
      puts "in set up stage with byes"
      genre = args[:genre]
      song_total = genre.songs.count
      next_highest_cap = 2**(song_total.bit_length)
      num_byes = next_highest_cap - song_total
      total_pair_ids = next_highest_cap/2
      pair_id_array = (1..total_pair_ids).to_a
      puts "made the pair id array"
      bye_id_array = []
      # remove the bye'd songs from the initial pair_id assignment
      (1..num_byes).each do
        random_pair_id = pair_id_array.sample
        bye_id_array.push(random_pair_id)
        pair_id_array.delete(random_pair_id)
      end
      puts "made bye ids"
      i = 0
      # loop through a randomly ordered list of song pairs
      # but leave out num_byes songs so that we can give them byes
      genre.songs.order('RANDOM()').limit(song_total - num_byes).each_slice(2) do |song1, song2|
        song1.update_attribute('pair_id', pair_id_array[i])
        song2.update_attribute('pair_id', pair_id_array[i])
        i = i + 1
      end
      puts "Assigned non-bye pair ids"
      # loop through the remaining songs and give them the
      # bye_id_array pair_ids
      n = 0
      genre.songs.where(pair_id: nil).each do |song|
        song.update_attribute('pair_id', bye_id_array[n])
        n = n + 1
        song.user.update_attribute('notification', "bye")
      end
      puts "assigned pair_ids with byes"
      User.all.each do |user|
        new_bracket_order = user.bracket_order
        new_bracket_order[genre.name] = pair_id_array.shuffle
        user.update_attribute('song_queue', new_bracket_order)
        user.update_attribute('bracket_order', new_bracket_order)
      end



      puts "assigned songs_to_vote with byes"
    # end
  end








# ------------ State: "in progress" ------------ #

  desc "Calculate votes, assign new pair ids, and update users' song queues"
  task :progress_round, [:genre] => [:environment] do |task, args|
    Rake::Task["round:calculate_votes"].invoke(args[:genre])
    Rake::Task["round:calculate_votes"].reenable

    if args[:genre].state == "ended"
      # do nothing if its ended so the next day remains the next week
    elsif args[:genre].next_day == "Sunday"
      args[:genre].update_attribute("next_day", "Wednesday")
    elsif args[:genre].next_day == "Wednesday"
      args[:genre].update_attribute("next_day", "Sunday")
    end


    Rake::Task["round:assign_new_pairs_and_queues"].invoke(args[:genre])
    Rake::Task["round:assign_new_pairs_and_queues"].reenable
  end

  desc "For each pair of songs, deactivate the one that has less votes"
  task :calculate_votes, [:genre] => [:environment] do |task, args|
    # Genre.all.each do |genre|
      genre = args[:genre]
      song_total = genre.songs.active.count
      # if the number of entered songs is a power of 2
      if !(song_total.to_s(2).count('1') == 1)
        song_total = 2**(song_total.bit_length)
      end
      total_pair_ids = song_total/2
      pair_id_array = (1..total_pair_ids).to_a
      pair_id_array.each do |pair_id|
        song_pair = genre.songs.active.where(pair_id: pair_id)
        # if the song has a bye, it will be the only song with that pair_id
        if song_pair.count == 1
          # do nothing if the song has a bye
        elsif song_pair[0].votes > song_pair[1].votes
          song_pair[1].update_attribute('active', 'false')
          song_pair[0].update_attribute('votes', 0)
          song_pair[0].user.update_attribute('notification', "won")
          song_pair[1].user.update_attribute('notification', "lost")
        elsif song_pair[0].votes < song_pair[1].votes
          song_pair[0].update_attribute('active', 'false')
          song_pair[1].update_attribute('votes', 0)
          song_pair[0].user.update_attribute('notification', "lost")
          song_pair[1].user.update_attribute('notification', "won")
        # consider adding 'followers' as an attribute to Song in order to make this more efficient
        # elsif RSpotify::Track.find(song_pair[0].track_id).artists[0].followers["total"] > RSpotify::Track.find(song_pair[1].track_id).artists[0].followers["total"]
        #   song_pair[1].update_attribute('active', 'false')
        # elsif RSpotify::Track.find(song_pair[1].track_id).artists[0].followers["total"] > RSpotify::Track.find(song_pair[0].track_id).artists[0].followers["total"]
        #   song_pair[0].update_attribute('active', 'false')
        else
          song_pair[1].update_attribute('active', 'false')
          song_pair[0].update_attribute('votes', 0)
          song_pair[0].user.update_attribute('notification', "won")
          song_pair[1].user.update_attribute('notification', "lost")
        end
      end

      puts "calculated votes"
      if genre.songs.active.count == 1
        args[:genre].update_attribute("state", "ended")
        last_song = genre.songs.active.first
        if Winner.where(genre: genre.name).count > 0
          # Winner.where(genre: genre.name).first.update_attribute('active', false)
          Winner.where(genre: genre.name).update_all('active': false)
        end
        winning_song = {active: true, genre: genre.name, track_id: last_song.track_id, artist_id: last_song.user.artist_id, user_id: last_song.user.id, votes: last_song.votes, round: last_song.round + 1}
        Winner.create! winning_song
        puts "made a winner song"
        Rake::Task["round:clear_past_stage"].invoke(genre)
        Rake::Task["round:clear_past_stage"].reenable
      end
    # end
  end

  desc "Assign new pair_ids (1 for 1, 2; 2 for 3, 4;, etc.) and reset users' song_queue"
  task :assign_new_pairs_and_queues, [:genre] => [:environment] do |task, args|
    # Genre.all.each do |genre|
      genre = args[:genre]
      if genre.state == "in progress"
        genre.update_attribute('round', genre.round + 1)
        song_total = genre.songs.active.count
        total_pair_ids = song_total/2
        pair_id_array = (1..total_pair_ids).to_a
        n = 0
        genre.songs.active.order('pair_id').each_slice(2) do |song1, song2|
          # update the round of the songs
          song1.update_attribute('round', song1.round + 1)
          song2.update_attribute('round', song2.round + 1)

          song1.update_attribute('pair_id', pair_id_array[n])
          song2.update_attribute('pair_id', pair_id_array[n])
          n = n + 1
        end
        puts "updated song pair_ids"

        i = 0
        User.all.each do |user|
          new_bracket_array = []
          user.bracket_order[genre.name].each do |pair_id|
            new_bracket_array.push((pair_id+1)/2)
          end
          byed_songs = pair_id_array - new_bracket_array

          new_bracket_order = user.bracket_order
          new_bracket_order[genre.name] = new_bracket_array.uniq + byed_songs.shuffle
          user.update_attribute('song_queue', new_bracket_order)
          user.update_attribute('bracket_order', new_bracket_order)
        end
      end
    # end
  end

  desc "Clears the songs from the genre, the artist_ids from the entered users, and resets the bracket orders/songs queues"
  task :clear_past_stage, [:genre] => [:environment] do |task, args|
    genre = args[:genre]

    genre.songs.each do |song|
      song.user.update_attribute('artist_id', nil)
      song.delete
    end
    User.all.each do |user|
      new_bracket_order = user.bracket_order
      new_bracket_order[genre.name] = []
      user.update_attribute('song_queue', new_bracket_order)
      user.update_attribute('bracket_order', new_bracket_order)
      user.update_attribute("notification", nil)
    end
    puts "cleared past stage"
  end









# ------------ Testing Set ------------ #

  desc "Add filler songs in order to meet participant requirement"
  task fill_songs: :environment do
    Genre.all.each do |genre|
      song_total = genre.songs.count

      # if the total number of songs is not a power of two
      if !(song_total.to_s(2).count('1') == 1) || song_total < 16

        # find the next highest power of 2
        if song_total < 16
          next_highest_cap = 16
        else
          next_highest_cap = 2**(song_total.bit_length)
        end
        songs_left = next_highest_cap - song_total
        filler_song_ids = []

        # could add: Song.pluck("track_id").each do |track_id|, to ensure unique ids and increase efficiency
        while filler_song_ids.count < songs_left
          difference = songs_left - filler_song_ids.count
          if difference > 100
            recommendations = RSpotify::Recommendations.generate(limit: 100, seed_tracks: [Song.pluck("track_id").sample], max_popularity: 60)
            filler_song_ids += recommendations.tracks.map(&:id)
            filler_song_ids = filler_song_ids.uniq
          else
            recommendations = RSpotify::Recommendations.generate(limit: difference, seed_tracks: [Song.pluck("track_id").sample], max_popularity: 60)
            filler_song_ids += recommendations.tracks.map(&:id)
            filler_song_ids = filler_song_ids.uniq
          end
        end
        filler_songs = []
        (1..(songs_left - 3) ).each do |i|
          # go through the filler song ids and create a song from each of them
          new_filler_song = {active: true, track_id: filler_song_ids[i-1], votes: 0, pair_id: nil, user_id: Song.count + 5 + i, genre_id: genre.id}
          filler_songs.push(new_filler_song)
        end
        filler_songs.each { |song| Song.create! song }
      end
    end
  end

end
