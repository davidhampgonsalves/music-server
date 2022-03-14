#!/bin/bash

cd /mnt/dietpi_userdata/itunes-music/Automatically\ Add\ to\ Music.localized/Not\ Added.localized/

find -name "*.flac" -not -name '.*' -exec ffmpeg -i {} -acodec libmp3lame -ab 256k {}.mp3 \;
find -name "*.mp3" -not -name '.*' -exec mv {} ../ \;
find -name "*.flac" -not -name '.*' -exec rm {} \;
