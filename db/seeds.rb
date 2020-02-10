# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# firstly delete any existing data
# User.delete_all
# now build up an array
users = [
  {id: 2, password: 'abcdefgh', email:'1-@test.com', uid:'user-1', provider: 'spotify', artist_id: '4tZwfgrHOc3mvqYlEYSvVi'},
  {id: 3, password: 'abcdefgh', email:'2-@test.com', uid:'user-2', provider: 'spotify', artist_id: '0MeLMJJcouYXCymQSHPn8g'},
  {id: 4, password: 'abcdefgh', email:'3-@test.com', uid:'user-3', provider: 'spotify', artist_id: '2QsynagSdAqZj3U9HgDzjD'},
  {id: 5, password: 'abcdefgh', email:'4-@test.com', uid:'user-4', provider: 'spotify', artist_id: '3qNVuliS40BLgXGxhdBdqu'},
  {id: 6, password: 'abcdefgh', email:'5-@test.com', uid:'user-5', provider: 'spotify', artist_id: '6VD4UEUPvtsemqD3mmTqCR'},
  {id: 7, password: 'abcdefgh', email:'6-@test.com', uid:'user-6', provider: 'spotify', artist_id: '6qqNVTkY8uBg9cP3Jd7DAH'},
  {id: 8, password: 'abcdefgh', email:'7-@test.com', uid:'user-7', provider: 'spotify', artist_id: '4F84IBURUo98rz4r61KF70'},
  {id: 9, password: 'abcdefgh', email:'8-@test.com', uid:'user-8', provider: 'spotify', artist_id: '3WrFJ7ztbogyGnTHbHJFl2'},
  {id: 10,password: 'abcdefgh',  email:'9-@test.com', uid:'user-9', provider: 'spotify', artist_id: '20JZFwl6HVl6yg8a4H3ZqK'},
  {id: 11,password: 'abcdefgh',  email:'10-@test.com', uid:'user-10', provider: 'spotify', artist_id: '3TOqt5oJwL9BE2NG9MEwDa'},
  {id: 12,password: 'abcdefgh',  email:'11-@test.com', uid:'user-11', provider: 'spotify', artist_id: '6LuN9FCkKOj5PcnpouEgny'},
  {id: 13,password: 'abcdefgh',  email:'12-@test.com', uid:'user-12', provider: 'spotify', artist_id: '2q1NYivkWMAeUxWZiCTyFR'},
  {id: 14,password: 'abcdefgh',  email:'13-@test.com', uid:'user-13', provider: 'spotify', artist_id: '3UvcmAOZt64oKpP95f6MMM'},
  {id: 15,password: 'abcdefgh',  email:'14-@test.com', uid:'user-14', provider: 'spotify', artist_id: '4mYFgEjpQT4IKOrjOUKyXu'},
  {id: 16,password: 'abcdefgh',  email:'15-@test.com', uid:'user-15', provider: 'spotify', artist_id: '06HL4z0CvFAxyc27GXpf02'}
]


# # spotify:artist:4tZwfgrHOc3mvqYlEYSvVi
# # spotify:artist:0MeLMJJcouYXCymQSHPn8g
# # spotify:artist:2QsynagSdAqZj3U9HgDzjD
# # spotify:artist:3qNVuliS40BLgXGxhdBdqu
# # spotify:artist:6VD4UEUPvtsemqD3mmTqCR
# # spotify:artist:6qqNVTkY8uBg9cP3Jd7DAH
# # spotify:artist:4F84IBURUo98rz4r61KF70
# # spotify:artist:3WrFJ7ztbogyGnTHbHJFl2
# # spotify:artist:20JZFwl6HVl6yg8a4H3ZqK

# # spotify:artist:3TOqt5oJwL9BE2NG9MEwDa
# # spotify:artist:6LuN9FCkKOj5PcnpouEgny
# # spotify:artist:2q1NYivkWMAeUxWZiCTyFR
# # spotify:artist:3UvcmAOZt64oKpP95f6MMM
# # spotify:artist:4mYFgEjpQT4IKOrjOUKyXu
# # spotify:artist:06HL4z0CvFAxyc27GXpf02
users.each { |user| User.create! user }


# firstly delete any existing data
# Song.delete_all
# now build up an array
songs = [
  {active: true, track_id: '0DiWol3AO6WpXZgp0goxAV', votes: 0, pair_id: nil, user_id: 2, genre_id: 1 },
  {active: true, track_id: '62CprXvSWsKBvYu3Yba55A', votes: 0, pair_id: nil, user_id: 3, genre_id: 1 },
  {active: true, track_id: '6A9mKXlFRPMPem6ygQSt7z', votes: 0, pair_id: nil, user_id: 4, genre_id: 1 },
  {active: true, track_id: '4ytyLpIwUXbdFsNOvgNnmP', votes: 0, pair_id: nil, user_id: 5, genre_id: 1 },
  {active: true, track_id: '3haS1MDe2Zh8jJaeiiymSt', votes: 0, pair_id: nil, user_id: 6, genre_id: 2 },
  {active: true, track_id: '6cLxofxCjrFpQYtifjK5Vf', votes: 0, pair_id: nil, user_id: 7, genre_id: 2 },
  {active: true, track_id: '7i6r9KotUPQg3ozKKgEPIN', votes: 0, pair_id: nil, user_id: 8, genre_id: 2 },
  {active: true, track_id: '5ylLypaOksxWd75YrGtx2N', votes: 0, pair_id: nil, user_id: 9, genre_id: 2 },
  {active: true, track_id: '1S30kHvkkdMkcuCTGSgS41', votes: 0, pair_id: nil, user_id: 10, genre_id: 3 },
  {active: true, track_id: '5hkgrWxkobGtg30I7DsfVu', votes: 0, pair_id: nil, user_id: 11, genre_id: 3 },
  {active: true, track_id: '1ToprX3cpBiXoAe5eNSk74', votes: 0, pair_id: nil, user_id: 12, genre_id: 3 },
  {active: true, track_id: '3n6jQYWcuthd3U4gyLE48c', votes: 0, pair_id: nil, user_id: 13, genre_id: 3 },
  {active: true, track_id: '3BQLTtpQOYGXQY2lT3ZZeU', votes: 0, pair_id: nil, user_id: 14, genre_id: 4 },
  {active: true, track_id: '3QchgGmYssZxHOlIh3lgRs', votes: 0, pair_id: nil, user_id: 15, genre_id: 4 },
  {active: true, track_id: '4t0OI7XrODjSkAu3bTPmWj', votes: 0, pair_id: nil, user_id: 16, genre_id: 4 }
]

# spotify:track:0DiWol3AO6WpXZgp0goxAV
# spotify:track:62CprXvSWsKBvYu3Yba55A
# spotify:track:6A9mKXlFRPMPem6ygQSt7z
# spotify:track:4ytyLpIwUXbdFsNOvgNnmP
# spotify:track:3haS1MDe2Zh8jJaeiiymSt
# spotify:track:6cLxofxCjrFpQYtifjK5Vf
# spotify:track:7i6r9KotUPQg3ozKKgEPIN
# spotify:track:5ylLypaOksxWd75YrGtx2N
# spotify:track:1S30kHvkkdMkcuCTGSgS41

# spotify:track:5hkgrWxkobGtg30I7DsfVu
# spotify:track:1ToprX3cpBiXoAe5eNSk74
# spotify:track:3n6jQYWcuthd3U4gyLE48c
# spotify:track:3BQLTtpQOYGXQY2lT3ZZeU
# spotify:track:3QchgGmYssZxHOlIh3lgRs
# spotify:track:4t0OI7XrODjSkAu3bTPmWj

#now process the array using an iterator
songs.each { |song| Song.create! song }