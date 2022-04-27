require './input_functions'

#Misc
module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Album
	attr_accessor :id, :title, :artist, :genre, :tracks

	def initialize (id, title, artist, genre, tracks)
    @id = id
		@title = title
		@artist = artist
		@genre = genre
		@tracks = tracks
  end
end

class Track
	attr_accessor :name, :location

	def initialize (name, location)
		@name = name
		@location = location
	end
end

# $gid = 1
#*****************************************************************
# Read & Print Album/s
def read_album(music_file, a_id)
  id = a_id
  artist = music_file.gets.chomp
  title = music_file.gets.chomp
  genre = music_file.gets.to_i
  tracks = read_tracks(music_file)
  if tracks.length < 15
    album = Album.new(id, title, artist, genre, tracks)
    # $gid += 1
  else
    album = Null
    puts "Error! #{album.title} has more than 15 tracks."
  end
  return album
end
#***************************************
#Print Album/s
def print_albums(albums)
  i = 0
  while (i < albums.length)
		print_album(albums[i])
		i += 1
  end
end

# Take a Single Album then print it
def print_album(album)
  puts('Album ID: ' + album.id.to_s)
  puts('-=' + $genre_names[album.genre] + '=-')
	puts('> ' + album.title.upcase.chomp + ' by ' + album.artist)
  puts"\n"
end
#*****************************************************************
# Read & Print Track/s
def read_tracks(music_file)
	count = music_file.gets.to_i()
  tracks = Array.new()
	index = 0

    while (index < count)
        track = read_track(music_file)
        tracks << track
        index += 1
    end
	return tracks
end

def read_track(music_file)
  name = music_file.gets
  location = music_file.gets
  track = Track.new(name, location)
  return track
end
#***************************************
#Print Track/s
def print_tracks(tracks)
  i = 0 
  while (i < tracks.length)
    print_track(tracks[i])
    i += 1
  end
end

# Takes a single track and prints it to the terminal
def print_track(track)
  validation = false
  puts(track.name)
  puts(track.location)
  if validation == true
    puts(track.location)
  end
  puts"\n"
end

# **********************************************
# 1. Read in Albums
def read_in_albums()
 system"cls"
  puts('********************')
  puts('** Read in Albums **')
  puts('********************')
  print('Please Enter Your File Name: ')
  file_name = gets.chomp

  if (File.file?(file_name))
      music_file = File.new(file_name, "r")
      album_count = music_file.gets().to_i()
      albums = []
      i = 0
    while i < album_count
      album = read_album(music_file, i+1)
      if album != nil
        albums << album
        i += 1
      else
        album = nil
        puts('No such file found.')
        read_string('Press ENTER to continue. . .')
      end
    end
    puts('File Loading . . .')
    puts('Please wait a sec.')
    0.step(100, 5) do |i|
      printf("\rProgress: [%-20s]", "#" * (i/5))
      sleep(0.02)
    end
    puts
    puts('File Loaded.')
    read_string('Press ENTER to continue. . .')
    return [albums, file_name]
    music_file.close()
  
  else
      puts('No such file found.')
      read_string('Press ENTER to continue. . .')
  end
end


# **********************************************
# 2. Display Albums
def display_albums(albums, selected_albums)
   system"cls"
    finished = false
    puts('********************')
    puts('** Display Albums **')
    puts('********************')
    puts('1. Display All')
    puts('2. Display All Genres')
    puts('3. Back to Menu')
    choice = read_integer_in_range("Please enter your choice: ", 1, 3)
    case choice
    when 1
      display_all(albums)
      read_string('Press ENTER to continue. . .')
    when 2
      display_genres(albums)
      read_string("Press ENTER To Continue...")
    when 3
      finished = true
    else
      puts('Please select again.')
    end
end

# 2.1 Display All
def display_all(albums)
  puts('All Albums')
  for album in albums
    print_album(album)
  end
end

# 2.2 Display Genre
def display_genres(albums)
  puts('Select Genre')
  puts('*****************')
  i = 1
  while i < $genre_names.length
    puts(i.to_s + ". " + $genre_names[i] )
    i+=1
  end
  puts('*****************')

  genre_id = read_integer_in_range("Select your genre: ",1, $genre_names.length)
  for album in albums
    if album.genre == genre_id   
      print_album(album)
    end
  end
end

# **********************************************
# 3. Play an Album or Search
def play_menu(albums, selected_albums)
  finished = false
  begin
  system'cls'
  puts('Play Menu')
  puts('*******************')
  puts('1. Play by ID')
  puts('2. Search')
  puts('3. Back to Menu')
  choice = read_integer_in_range("Option: ", 1, 3)
  case choice
  when 1
    puts('Please select an album below.')
    display_all(albums)
    album_pick = play_by_id(selected_albums)
    track_pick = select_track(album_pick)
    if track_pick != nil
      play_track(track_pick)
    else
      puts('This Album has no track inside.')
      read_string('Press ANY go back back Play Menu.')
    end
  when 2
   search_menu(selected_albums)
  when 3
    finished = true
  else
    puts('Please select again.')
  end
  end until finished
end

#******
#pick a single album in albums array according to its ID
def play_by_id(selected_albums)
  count = selected_albums.length
  album_id = read_integer_in_range("Album ID: ",1,count)
  album_pick = selected_albums[album_id-1]
  return album_pick
end

def search_menu(selected_albums)
   finished = false
    begin
     system"cls"
      puts('Search for Album')
      puts('*************************')
      puts('1. Search by Genre')
      puts('2. Search by Title')
      puts('3. Back to Play Menu')
      choice = read_integer_in_range("Option: ", 1, 3)
      case choice
      when 1
        display_genres(selected_albums)
        album_pick = play_by_id(selected_albums)
        track_pick = select_track(album_pick)
        if track_pick != nil
          play_track(track_pick)
        else
          puts('This Album has no track inside.')
          read_string('Press ANY go back back Play Menu.')
        end
      when 2
        search_string = read_string("Search Title: ")
        index = play_by_search(selected_albums, search_string)
        if index > -1
          album_pick = selected_albums[index]
          track_pick = select_track(album_pick)
          if track_pick != nil
            play_track(track_pick)
          else
            puts('This Album has no track inside.')
            read_string('Press ANY go back back Play Menu.')
          end
        else
          puts "Title not found"
          read_string('Press ANY go back back Play Menu.')
        end
      when 3
        finished = true
      else
        puts('Please Select Again.')
      end
      end until finished
end

def play_by_search(selected_albums, search_string)
  index = 0
	found_index = -1
		while index < selected_albums.length
			if selected_albums[index].title.chomp == search_string.chomp
				 found_index = index
			end
			index += 1
		end
	return found_index
end

#***************************
def select_track(album_pick)
  tracks = album_pick.tracks
  count = tracks.length
  if count < 1
    track_pick = nil
    return track_pick
  else
   system"cls"
    puts('Please select a track below')
    puts('**********************************')
    for track in tracks
      print_track(track)
    end
    track_number = read_integer_in_range("Track Number:",1,count)
    track_pick = tracks[track_number-1]
    return track_pick
  end
end

def play_track(track_pick)
  puts('Playing')
  track_pick = print_track(track_pick)
  sleep(4)
end

# **********************************************
# 4. Update Albums
def update_menu(albums,updating_status)
    system"cls"
    puts('*****************************')
    puts('**Update an Album Info**')
    puts('*****************************')
    puts('Please select an album below.')
    display_all(albums)
    album_pick = play_by_id(albums)
    update_album(album_pick, updating_status)
end

def update_album(album_pick, updating_status)
  finished = false
  begin
 system"cls"
  puts('Update Album')
  puts('1. Update Title')
  puts('2. Update Genre')
  puts('3. Update Track')
  puts('4. Not this Album? Take me back. ')
  choice = read_integer_in_range('Option: ',1,4)
  case choice
  when 1
    puts("Current Album Title: #{album_pick.title}")
    album_pick.title = read_string("New Album Title: ")
    updated_info(album_pick, album_pick.tracks)
    updating_status = true
  when 2
    puts("Current Album Genre: #{album_pick.genre} " + $genre_names[album_pick.genre])
    album_pick.genre = read_integer("New Album Genre (number): ")
    updated_info(album_pick, album_pick.tracks)
    updating_status = true
  when 3
    track_pick = select_track(album_pick)
    if track_pick != nil
          update_track(track_pick)
          updated_info(album_pick, album_pick.tracks)
          updating_status = true
    else
      puts('This Album has no track inside.')
      read_string('Press ANY go back back Play Menu.')
    end
  when 4
    finished = true
  else
    puts('Please Select Again.')
  end
  end until finished
end

def updating(albums, file_name)
  puts "Updating before leaving..."
  update_file(albums, file_name)
  0.step(100, 5) do |i|
    printf("\rProgress: [%-20s]", "#" * (i/5))
    sleep(0.02)
  end
  puts('Updated.')
  system"cls"
  puts('Goodbye!')
  read_string("Press Enter To Exit...")
  finished = true
end

def update_track(track_pick)
    finished = false
  begin
 system"cls"
  puts('**********************************')
  puts('Update Track')
  puts('1. Update Filename')
  puts('2. Update Location')
  puts('3. Validate Updates or Not this track? Take me back. ')
  choice = read_integer_in_range('Option: ',1,3)
  case choice
  when 1
    puts "Current Track Title: #{track_pick.name}"
    track_pick.name = read_string("New Track Title: ")
    updating_status = true
  when 2
    puts "Current Album Genre: #{track_pick.location}"
    track_pick.location = read_string("New Track Location: ")
    updating_status = true
  when 3
    finished = true
  else
    puts('Please Select Again.')
  end
  end until finished
end

def updated_info(album_pick, tracks)
  system"cls"
  validation = true
  puts('**********************************')
  puts('Updated Album Info')
  puts"\n"
  puts('Album ID: ' + album_pick.id.to_s)
  puts('-=' + $genre_names[album_pick.genre] + '=-')
	puts('> ' + album_pick.title.upcase.chomp + ' by ' + album_pick.artist)
  puts('Track List:')
  print_tracks(tracks)
  read_string('Press ANY go back back Update Menu.')
  updating_status = true
  return updating_status
end

def update_file(albums, file_name)
  file = File.new(file_name, "w")
  album_amount = albums.length
  file.puts(album_amount)
  for album in albums
    tracks = album.tracks
    file.puts(album.artist)
    file.puts(album.title)
    file.puts(album.genre)
    track_amount = tracks.length
    file.puts(track_amount)
    for track in tracks
      file.puts(track.name)
      file.puts(track.location)
    end
  end
  file.close
end

# **********************************************
# MAIN
def main_menu()
  albums = Array.new
  finished = false
  updating_status = false
  begin
   system"cls"
    puts('*************')
    puts('**Main Menu**')
    puts('*************')
    puts('1. Read in Albums')
    puts('2. Display Albums')
    puts('3. Select an Album to play')
    puts('4. Update an existing Albums')
    puts('5. Exit the application')
    choice = read_integer_in_range("Please enter your choice: ", 1, 5)
    case choice
    when 1
      data_array = read_in_albums()
      albums = data_array[0]
      file_name = data_array[1]
      selected_albums = albums
    when 2
      if albums.length > 0
        selected_albums = display_albums(albums, selected_albums)
      else
        puts("You have no selected albums")
        read_string("Press ENTER To Continue...")
      end
    when 3
      if albums.length > 0
        play_menu(albums, selected_albums)
      else
        puts("You have no selected albums")
        read_string("Press ENTER To Continue...")
      end
    when 4
      if albums.length > 0
        updating_status = update_menu(albums, updating_status)
      else
        puts("You have no selected albums.")
        read_string("Press Enter To Continue...")
      end
    when 5
      if updating_status = true
        updating(albums, file_name)
        exit!
      else
        puts("You have no selected albums.")
        read_string("Press Enter To Continue...")
      end
    else
      puts("Please select again.")
    end
  end until finished
end

main_menu()