require 'open-uri'

def clean(string)
    string.downcase.gsub(' ', '')
end

def song_link_for(artist, song)
    begin
        # Song titles on azlyrics can have numbers in them, search the artist listing for the song
        open("http://www.azlyrics.com/#{artist[0]}/#{artist}.html").each do |line|
            return line.split("\"")[1] if line.include? song and line.include? '.html'
        end
        puts "No lyrics for that song sorry"; exit
    rescue OpenURI::HTTPError
        puts 'No artist called that sorry'; exit
    end
end

artist = clean(ENV['ARTIST'] ||= 'nirvana')
song = clean(ENV['SONG'] ||= 'in bloom')

song_link = song_link_for(artist, song)

lyrics_started = false
open("http://www.azlyrics.com/#{artist[0]}/#{song_link}").each do |line|
    # azlyrics has html comments which makes it very easy to spot the start and end
    break if line.include? '<!-- end of lyrics -->'

    # Remove any HTML gubbins from the lyrics
    puts line.gsub(%r{</?[^>]+?>}, '') if lyrics_started
    lyrics_started = true if line.include? '<!-- start of lyrics -->'
end
