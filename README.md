## Restart services
sudo systemctl restart navidrome.service
sudo systemctl restart smbd

## Convert to 480p
for i in *; do ffmpeg -i "$i" -s hd360 -c:v libx264 -crf 23 -c:a aac -strict -2 "${i}.mkv"; done
