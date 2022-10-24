What's new in this fork?
========================

I have updated this script to make it more resilient.
The old script tried to construct the address (on AZLyrics) of the lyrics page from the artist name and song name but that often failed.
This version creates a search url instead and selects the first result.



command-line-lyrics
===================

Ruby script to print out song lyrics on the commandline

Example
=======
Search for Fiona Apple lyrics: 

    $ ARTIST=apple SONG="Every single night" ruby lyrics.rb 

Or search using mpc to automatically provide artist and title if you use the Music Player Daemon

    ARTIST=$(mpc -f %artist% | head -n 1) SONG=$(mpc -f %title% | head -n 1) ruby lyrics.rb

    Every single night
    I endure the flight
    Of little wings of white-flamed
    Butterflies in my brain
    These ideas of mine
    Percolate the mind
    Trickle down the spine
