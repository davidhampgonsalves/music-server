#!/bin/bash

# delete songs with 1 star rating or that are hearted
sqlite3 /home/david/navidrome/data/navidrome.db "select path from annotation a, media_file f where a.item_id = f.id AND (a.starred OR a.rating = 1);" | xargs -d '\n' rm

# delete albums with 1 star rating or that are hearted
sqlite3 /home/david/navidrome/data/navidrome.db "select path from annotation a, media_file f, album al where a.item_id = al.id AND f.album_id = al.id AND (a.starred OR a.rating = 1);" | xargs -d '\n' rm

# delete duplicate tracks
sqlite3 /home/david/navidrome/data/navidrome.db "SELECT path FROM media_file WHERE rowid NOT IN (SELECT MIN(rowid) FROM media_file GROUP BY artist_id, album_id, title, size);" | xargs -d '\n' rm


