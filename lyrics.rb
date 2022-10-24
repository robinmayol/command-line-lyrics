require 'open-uri'

def clean(string)
    string.downcase.gsub(' ', '')
end

searchartist = ENV['ARTIST']
searchartist = searchartist.downcase.gsub(' ', '+')
# print searchartist
searchsong = ENV['SONG']
searchsong = searchsong.downcase.gsub(' ', '+')
# print searchsong
def song_link_for(searchartist, searchsong)
    begin
        # print "https://search.azlyrics.com/search.php?q=#{searchartist}+#{searchsong}&x=0f58cfda39487ca4460bd2df9b8b7c71769dd2df71e5724a1c8ffe1a20d47407"
        # Song titles on azlyrics can have numbers in them, search the artist listing for the song
        URI.open("https://search.azlyrics.com/search.php?q=#{searchartist}+#{searchsong}&x=0f58cfda39487ca4460bd2df9b8b7c71769dd2df71e5724a1c8ffe1a20d47407",'User-Agent' => 'Mozilla').each do |line|
            return line.split("\"")[1] if line.include? '/lyrics/' and line.include? '.html'
        end
        puts "No lyrics for that song sorry"; exit
    rescue OpenURI::HTTPError
        puts 'No artist called that sorry'; exit
    end
end

song_link = song_link_for(searchartist, searchsong)

lyrics_started = false
URI.open("#{song_link}",'User-Agent' => 'Mozilla').each do |line|
    # azlyrics has html comments which makes it very easy to spot the start and end
    break if line.include? '<!-- MxM banner -->'

    # Remove any HTML gubbins from the lyrics
    puts line.gsub(%r{</?[^>]+?>}, '') if lyrics_started
    lyrics_started = true if line.include? '<!-- Usage of azlyrics.com '
end
