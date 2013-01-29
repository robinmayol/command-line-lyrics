require 'open-uri'

def clean(string)
    string.downcase.gsub(' ', '')
end

artist = clean(ENV['ARTIST'] ||= 'nirvana')
song = clean(ENV['SONG'] ||= 'in bloom')

song_link = nil
begin
    # Song titles on azlyrics can have numbers in them, search the artist listing for the song
    open("http://www.azlyrics.com/#{artist[0]}/#{artist}.html").each do |line|
        if line.include? song and line.include? '.html'
            song_link = line.split("\"")[1]
            break 
        end
    end
rescue OpenURI::HTTPError
    puts 'No artist called that sorry'; exit
end

if song_link.nil?
    puts "No lyrics for that song sorry"; exit
end

lyrics_started = false
# azlyrics has html comments which makes it very easy to spot the start and end
open("http://www.azlyrics.com/#{artist[0]}/#{song_link}").each do |line|
    break if line.include? '<!-- end of lyrics -->'
    
    # Remove any HTML gubbins from the lyrics
    puts line.gsub(%r{</?[^>]+?>}, '') if lyrics_started
    lyrics_started = true if line.include? '<!-- start of lyrics -->'
end
