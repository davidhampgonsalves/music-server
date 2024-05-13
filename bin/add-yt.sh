#!/bin/bash
yt-dlp -o "%(id)s.%(ext)s" --audio-format mp3 --embed-metadata --parse-metadata "title:%(artist)s - %(title)s" --embed-thumbnail -x $1
mv $1.mp3 /Volumes/sharing/music