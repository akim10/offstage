namespace :round do

# ------------ State: "not started", do these to start the stage ------------ #
  desc "Determining what action to do for each of the genres"
  task determine_action: :environment do
    require 'date'
    start_date = Date.new(2021,7,9)
    if Date.today >= start_date
      if ['Monday', 'Friday'].include? Date.today.strftime("%A")
        Genre.all.each do |genre|
          if genre.state == "in progress"
            puts "state: in progress"
            Rake::Task["round:progress_round"].invoke(genre)
            Rake::Task["round:progress_round"].reenable
          elsif genre.state == "ended"
            puts "state: ended"
            if !(Date.today.strftime("%A") == genre.next_day)
              Rake::Task["round:start_stage"].invoke(genre)
              Rake::Task["round:start_stage"].reenable
            end
          elsif genre.state == "not started"
            puts "state: not started"
            Rake::Task["round:start_stage"].invoke(genre)
            Rake::Task["round:start_stage"].reenable
          end
        end
      end
    end
  end

  desc "Invoke the set up stage task depending on whether or not byes are needed"
  task :start_stage, [:genre] => [:environment] do |task, args|
    puts "in start stage"
    if args[:genre].state == "ended"
      # do nothing if its ended so the next day resets properly
    else
      if args[:genre].next_day == "Friday"
        args[:genre].update_attribute("next_day", "Monday")
      elsif args[:genre].next_day == "Monday"
        args[:genre].update_attribute("next_day", "Friday")
      end
    end

    if args[:genre].songs.count < 32
      Rake::Task["round:fill_songs"].invoke(args[:genre])
      Rake::Task["round:fill_songs"].reenable
    end
    Rake::Task["round:set_up_stage"].invoke(args[:genre])
    Rake::Task["round:set_up_stage"].reenable
    args[:genre].update_attribute("state", "in progress")

    # unless args[:genre].songs.count < 2
    #   if args[:genre].songs.count.to_s(2).count('1') == 1
    #     Rake::Task["round:set_up_stage"].invoke(args[:genre])
    #     Rake::Task["round:set_up_stage"].reenable
    #   else
    #     Rake::Task["round:set_up_stage_with_byes"].invoke(args[:genre])
    #     Rake::Task["round:set_up_stage_with_byes"].reenable
    #   end
    #   args[:genre].update_attribute("state", "in progress")
    # end
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
        # song.user.update_attribute('notification', "bye")
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

    if args[:genre].next_day == "Monday"
      args[:genre].update_attribute("next_day", "Friday")
    elsif args[:genre].next_day == "Friday"
      args[:genre].update_attribute("next_day", "Monday")
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
          # song_pair[0].user.update_attribute('notification', "won")
          # song_pair[1].user.update_attribute('notification', "lost")
        elsif song_pair[0].votes < song_pair[1].votes
          song_pair[0].update_attribute('active', 'false')
          song_pair[1].update_attribute('votes', 0)
          # song_pair[0].user.update_attribute('notification', "lost")
          # song_pair[1].user.update_attribute('notification', "won")
        # consider adding 'followers' as an attribute to Song in order to make this more efficient
        # elsif RSpotify::Track.find(song_pair[0].track_id).artists[0].followers["total"] > RSpotify::Track.find(song_pair[1].track_id).artists[0].followers["total"]
        #   song_pair[1].update_attribute('active', 'false')
        # elsif RSpotify::Track.find(song_pair[1].track_id).artists[0].followers["total"] > RSpotify::Track.find(song_pair[0].track_id).artists[0].followers["total"]
        #   song_pair[0].update_attribute('active', 'false')
        else
          song_pair[1].update_attribute('active', 'false')
          song_pair[0].update_attribute('votes', 0)
          # song_pair[0].user.update_attribute('notification', "won")
          # song_pair[1].user.update_attribute('notification', "lost")
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
        winning_song = {active: true, genre: genre.name, track_id: last_song.track_id, artist_id: RSpotify::Track.find(last_song.track_id).artists[0].id, votes: last_song.votes, round: last_song.round + 1}
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
      # song.user.update_attribute('artist_id', nil)
      song.delete
    end
    User.all.each do |user|
      new_bracket_order = user.bracket_order
      new_bracket_order[genre.name] = []
      user.update_attribute('song_queue', new_bracket_order)
      user.update_attribute('bracket_order', new_bracket_order)
      # user.update_attribute("notification", nil)
    end
    puts "cleared past stage"
  end









# ------------ Testing Set ------------ #

  desc "Add filler songs in order to meet participant requirement"
  task :fill_songs, [:genre] => [:environment] do |task, args|
      # words to do a random search with
      genre = args[:genre]
      genreName = genre.name
      if genreName == "hiphop"
        genreName = "hip-hop"
      end
      if genreName == "indie"
        genreName = "indie-pop"
      end
      query_words = ["a", "able", "about", "account", "acid", "across", "act", "addition", "adjustment", "advertisement", "after", "again", "against", "agreement", "air", "all", "almost", "among", "amount", "amusement", "and", "angle", "angry", "animal", "answer", "ant", "any", "apparatus", "apple", "approval", "arch", "argument", "arm", "army", "art", "as", "at", "attack", "attempt", "attention", "attraction", "authority", "automatic", "awake", "baby", "back", "bad", "bag", "balance", "ball", "band", "base", "basin", "basket", "bath", "be", "beautiful", "because", "bed", "bee", "before", "behaviour", "belief", "bell", "bent", "berry", "between", "bird", "birth", "bit", "bite", "bitter", "black", "blade", "blood", "blow", "blue", "board", "boat", "body", "boiling", "bone", "book", "boot", "bottle", "box", "boy", "brain", "brake", "branch", "brass", "bread", "breath", "brick", "bridge", "bright", "broken", "brother", "brown", "brush", "bucket", "building", "bulb", "burn", "burst", "business", "but", "butter", "button", "by", "cake", "camera", "canvas", "card", "care", "carriage", "cart", "cat", "cause", "certain", "chain", "chalk", "chance", "change", "cheap", "cheese", "chemical", "chest", "chief", "chin", "church", "circle", "clean", "clear", "clock", "cloth", "cloud", "coal", "coat", "cold", "collar", "colour", "comb", "come", "comfort", "committee", "common", "company", "comparison", "competition", "complete", "complex", "condition", "connection", "conscious", "control", "cook", "copper", "copy", "cord", "cork", "cotton", "cough", "country", "cover", "cow", "crack", "credit", "crime", "cruel", "crush", "cry", "cup", "cup", "current", "curtain", "curve", "cushion", "damage", "danger", "dark", "daughter", "day", "dead", "dear", "death", "debt", "decision", "deep", "degree", "delicate", "dependent", "design", "desire", "destruction", "detail", "development", "different", "digestion", "direction", "dirty", "discovery", "discussion", "disease", "disgust", "distance", "distribution", "division", "do", "dog", "door", "doubt", "down", "drain", "drawer", "dress", "drink", "driving", "drop", "dry", "dust", "ear", "early", "earth", "east", "edge", "education", "effect", "egg", "elastic", "electric", "end", "engine", "enough", "equal", "error", "even", "event", "ever", "every", "example", "exchange", "existence", "expansion", "experience", "expert", "eye", "face", "fact", "fall", "false", "family", "far", "farm", "fat", "father", "fear", "feather", "feeble", "feeling", "female", "fertile", "fiction", "field", "fight", "finger", "fire", "first", "fish", "fixed", "flag", "flame", "flat", "flight", "floor", "flower", "fly", "fold", "food", "foolish", "foot", "for", "force", "fork", "form", "forward", "fowl", "frame", "free", "frequent", "friend", "from", "front", "fruit", "full", "future", "garden", "general", "get", "girl", "give", "glass", "glove", "go", "goat", "gold", "good", "government", "grain", "grass", "great", "green", "grey", "grip", "group", "growth", "guide", "gun", "hair", "hammer", "hand", "hanging", "happy", "harbour", "hard", "harmony", "hat", "hate", "have", "he", "head", "healthy", "hear", "hearing", "heart", "heat", "help", "high", "history", "hole", "hollow", "hook", "hope", "horn", "horse", "hospital", "hour", "house", "how", "humour", "I", "ice", "idea", "if", "ill", "important", "impulse", "in", "increase", "industry", "ink", "insect", "instrument", "insurance", "interest", "invention", "iron", "island", "jelly", "jewel", "join", "journey", "judge", "jump", "keep", "kettle", "key", "kick", "kind", "kiss", "knee", "knife", "knot", "knowledge", "land", "language", "last", "late", "laugh", "law", "lead", "leaf", "learning", "leather", "left", "leg", "let", "letter", "level", "library", "lift", "light", "like", "limit", "line", "linen", "lip", "liquid", "list", "little", "living", "lock", "long", "look", "loose", "loss", "loud", "love", "low", "machine", "make", "male", "man", "manager", "map", "mark", "market", "married", "mass", "match", "material", "may", "meal", "measure", "meat", "medical", "meeting", "memory", "metal", "middle", "military", "milk", "mind", "mine", "minute", "mist", "mixed", "money", "monkey", "month", "moon", "morning", "mother", "motion", "mountain", "mouth", "move", "much", "muscle", "music", "nail", "name", "narrow", "nation", "natural", "near", "necessary", "neck", "need", "needle", "nerve", "net", "new", "news", "night", "no", "noise", "normal", "north", "nose", "not", "note", "now", "number", "nut", "observation", "of", "off", "offer", "office", "oil", "old", "on", "only", "open", "operation", "opinion", "opposite", "or", "orange", "order", "organization", "ornament", "other", "out", "oven", "over", "owner", "page", "pain", "paint", "paper", "parallel", "parcel", "part", "past", "paste", "payment", "peace", "pen", "pencil", "person", "physical", "picture", "pig", "pin", "pipe", "place", "plane", "plant", "plate", "play", "please", "pleasure", "plough", "pocket", "point", "poison", "polish", "political", "poor", "porter", "position", "possible", "pot", "potato", "powder", "power", "present", "price", "print", "prison", "private", "probable", "process", "produce", "profit", "property", "prose", "protest", "public", "pull", "pump", "punishment", "purpose", "push", "put", "quality", "question", "quick", "quiet", "quite", "rail", "rain", "range", "rat", "rate", "ray", "reaction", "reading", "ready", "reason", "receipt", "record", "red", "regret", "regular", "relation", "religion", "representative", "request", "respect", "responsible", "rest", "reward", "rhythm", "rice", "right", "ring", "river", "road", "rod", "roll", "roof", "room", "root", "rough", "round", "rub", "rule", "run", "sad", "safe", "sail", "salt", "same", "sand", "say", "scale", "school", "science", "scissors", "screw", "sea", "seat", "second", "secret", "secretary", "see", "seed", "seem", "selection", "self", "send", "sense", "separate", "serious", "servant", "sex", "shade", "shake", "shame", "sharp", "sheep", "shelf", "ship", "shirt", "shock", "shoe", "short", "shut", "side", "sign", "silk", "silver", "simple", "sister", "size", "skin", "skirt", "sky", "sleep", "slip", "slope", "slow", "small", "smash", "smell", "smile", "smoke", "smooth", "snake", "sneeze", "snow", "so", "soap", "society", "sock", "soft", "solid", "some", "son", "song", "sort", "sound", "soup", "south", "space", "spade", "special", "sponge", "spoon", "spring", "square", "stage", "stamp", "star", "start", "statement", "station", "steam", "steel", "stem", "step", "stick", "sticky", "stiff", "still", "stitch", "stocking", "stomach", "stone", "stop", "store", "story", "straight", "strange", "street", "stretch", "strong", "structure", "substance", "such", "sudden", "sugar", "suggestion", "summer", "sun", "support", "surprise", "sweet", "swim", "system", "table", "tail", "take", "talk", "tall", "taste", "tax", "teaching", "tendency", "test", "than", "that", "the", "then", "theory", "there", "thick", "thin", "thing", "this", "thought", "thread", "throat", "through", "through", "thumb", "thunder", "ticket", "tight", "till", "time", "tin", "tired", "to", "toe", "together", "tomorrow", "tongue", "tooth", "top", "touch", "town", "trade", "train", "transport", "tray", "tree", "trick", "trouble", "trousers", "true", "turn", "twist", "umbrella", "under", "unit", "up", "use", "value", "verse", "very", "vessel", "view", "violent", "voice", "waiting", "walk", "wall", "war", "warm", "wash", "waste", "watch", "water", "wave", "wax", "way", "weather", "week", "weight", "well", "west", "wet", "wheel", "when", "where", "while", "whip", "whistle", "white", "who", "why", "wide", "will", "wind", "window", "wine", "wing", "winter", "wire", "wise", "with", "woman", "wood", "wool", "word", "work", "worm", "wound", "writing", "wrong", "year", "yellow", "yes", "yesterday", "you", "young"]
      song_total = genre.songs.count

      # if the participant cap isn't reached
      if song_total < 32
        next_highest_cap = 32
        songs_left = next_highest_cap - song_total
        staged_artists = []
        staged_songs = []
        filler_song_ids = []
        filler_songs = []
        while filler_song_ids.count < songs_left
          if genreName == "edm"
            genreName = ["edm", "dubstep"].sample
          end
          # puts "current songs filled: "
          # puts filler_song_ids.count 
          # puts "--------"
          # get random songs from this genre that aren't too popular
          search_query = "genre: " + genreName + " " + query_words.sample
          # puts "search query: "
          # puts search_query
          # puts "--------"
          searchResultsTotal = RSpotify::Track.search(search_query).total
          # wait to avoid too many requests
          sleep(4)
          # puts "total number of search results: "
          # puts searchResultsTotal
          # puts "--------"
          if searchResultsTotal >= 1000
            searchResults = RSpotify::Track.search(search_query, limit: 50, offset: rand(599..899))
          elsif searchResultsTotal < 1000 && searchResultsTotal > 150
            searchResults = RSpotify::Track.search(search_query, limit: 50, offset: searchResultsTotal-rand(49..99))
          else
            searchResults = RSpotify::Track.search(search_query, limit: 50)
          end

          searchResults.each do |song|
            if !(staged_artists.include? song.artists[0])
              staged_artists += [song.artists[0]]
              staged_songs += [song]
            end
          end

          cleanSongs = staged_songs
          # remove any with too many followers
          cleanSongs = cleanSongs.select {|song| song.artists[0].followers["total"] <= 25000}
          # remove any that have already been submitted
          cleanSongs = cleanSongs.reject {|song| (Song.pluck(:track_id)).include? song.id}
          # remove any that have already won
          cleanSongs = cleanSongs.reject {|song| (Winner.pluck(:track_id)).include? song.id}

          filler_song_ids += cleanSongs.map(&:id)
          filler_song_ids = filler_song_ids.uniq
          sleep(4)
        end
        # in order to minimize risk of race conditions, re-check the number of songs in the current genre
        songs_left = next_highest_cap - genre.songs.count
        [*0..songs_left-1].each do |i|
          # go through the filler song ids and create a song from each of them
          new_filler_song = {active: true, track_id: filler_song_ids[i], votes: 0, pair_id: nil, user_id: User.count + Song.count + 65000 + i, genre_id: genre.id}
          filler_songs.push(new_filler_song)
        end
        filler_songs.each { |song| Song.create! song }
      end
    end
end
