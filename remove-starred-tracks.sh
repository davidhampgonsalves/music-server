#!/bin/bash
sqlite3 /home/david/navidrome/data/navidrome.db "select path from annotation a, media_file f where a.item_id = f.id AND (a.starred OR a.rating = 1);" | xargs -d '\n' rm
sqlite3 /home/david/navidrome/data/navidrome.db "select path from annotation a, media_file f, album al where a.item_id = al.id AND f.album_id = al.id AND (a.starred OR a.rating = 1);" | xargs -d '\n' rm
