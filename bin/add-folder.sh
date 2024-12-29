#!/bin/bash
mkdir -p /tmp/music-to-transfer

find -E . -regex '.*\.(mp3|flac|wav)'  -exec bash -c 'F=$(cat /dev/urandom | gtr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1); ffmpeg -i "{}" -codec:a libmp3lame -qscale:a 6 "/tmp/music-to-transfer/$F.mp3"' \;

mv /tmp/music-to-transfer/* /Volumes/share/music

rm -rf /tmp/music-to-transfer
