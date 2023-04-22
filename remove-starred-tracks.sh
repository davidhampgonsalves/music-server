#!/bin/bash
sqlite3 /data/data/com.termux/files/home/navidrome/data/navidrome.db "select path from annotation a, media_file f where a.item_id = f.id AND (a.starred OR a.rating = 1);" | xargs -d '\n' rm
