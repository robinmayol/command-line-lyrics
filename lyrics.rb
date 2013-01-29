require 'open-uri'

def clean(string)
    string.downcase.gsub(' ', '')
end

artist = clean(ENV['ARTIST'] ||= 'nirvana')
song = clean(ENV['SONG'] ||= 'in bloom')

song_link = nil
begin
    open("http://www.azlyrics.com/#{artist[0]}/#{artist}.html").each do |line|
        if line.include? song and line.include? '.html'
            song_link = line.split("\"")[1]
            break 
        end
    end
rescue OpenURI::HTTPError
    puts 'No artist called that sorry'
    exit
end

if song_link.nil?
    puts "No lyrics for that song sorry"
    exit
end

lyrics_started = false
lyrics_finished = false

open("http://www.azlyrics.com/#{artist[0]}/#{song_link}").each do |line|
    lyrics_finished = true if line.include? '<!-- end of lyrics -->'
    puts line.gsub(%r{</?[^>]+?>}, '') if lyrics_started and not lyrics_finished
    lyrics_started = true if line.include? '<!-- start of lyrics -->'
end
