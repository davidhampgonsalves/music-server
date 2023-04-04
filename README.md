Setup for my personal [https://github.com/navidrome/navidrome](Navidrome) based music streaming server running on a non-rooted Samsung Galaxy S7 using [https://termux.dev/en/](Termux). 

## features
* Uses [https://wiki.termux.com/wiki/Termux:Boot](Termux:Boot) & [https://wiki.termux.com/wiki/Termux-services](Termux-services) to automatically start everything on boot.
* Automatically removes songs with ☆☆☆☆★ reviews.
* Uses Cloudflare for dynamic DNS updates.

## Add Music
I transfer music using SFTP after converting to OPUS. The S7 only has about 20GB of usable storage and this makes a big difference.

```
find . -iname '*.mp3' -exec bash -c 'D=$(dirname "{}"); B=$(basename "{}"); mkdir "$D/opus/"; ffmpeg -i "{}" -ab 320k -map_metadata 0:s:a:0 -id3v2_version 3 "$D/mp3/${B%.*}.mp3"' \;
```

## Install
* Install [https://f-droid.org/en/](F-Droid) and then Termux + Termux:Boot.
* Launch Termux:Boot and then exit.
* send this to your phone and paste into termux terminal.
```
pkg update && pkg upgrade && pkg add openssh -y
passwd "password" --stdin
ifconfig
whoami
sshd
```
* SSH into phone from computer.
ssh u0_a179@192.168.2.89 -p 8022
```
passwd
pkg add git wget neovim -y
git clone https://github.com/davidhampgonsalves/music-server.git
```

Termux can't run binaries, even if they are built for arm64. As such we will build navidrome via go run.
```
pkg add golang taglib
git clone https://github.com/navidrome/navidrome
// might want to checkout a specfic commit that matches a release
mkdir music
cd navidrome
cp music-server/navidrome.toml navidrome/
make setup

// building the navidrone UI OOM's on my Samsung Galaxy S7
// so build it on a PC (via cd ui ; npm install ; npm run build) and 
// then transfer the ui/build folder over via sftp

go mod download
go build

// setup sshd and navidrome as services
pkg install termux-services
mkdir -p $PREFIX/var/service/navidrome
mv ~/music-server/navidrome.runit.sh $PREFIX/var/service/navidrome/run
chmod ugo+x $PREFIX/var/service/navidrome/run
mkdir -p $PREFIX/var/service/navidrome/log
mkdir -p $PREFIX/var/log/sv/navidrome
ln -sf $PREFIX/share/termux-services/svlogger $PREFIX/var/service/navidrome/log/run
// Logs are at `cat $PREFIX/var/log/sv/navidrome/current` but do not seem to work
// sv up/down/status navidrome`
sv-enable sshd
sv-enable navidrome

mv music-server/boot/start-services .termux/boot/
```

* setup DNS - https://github.com/timothymiller/cloudflare-ddns
* copy music over to ~/music vis sftp

# DDNS
python venv creation(happening in start-sync.sh) was hanging so after installing the requirements from start-sync.sh I commented out everything except `cd ... ; python ...`.
```
git clone https://github.com/timothymiller/cloudflare-ddns.git
chmod +x /data/data/com.termux/files/home/cloudflare-ddns/start-sync.sh
chmod +x /data/data/com.termux/files/home/music-server/remove-starred-tracks.sh
ln -s /data/data/com.termux/files/home/music-server/cloudflare-ddns.config.json /data/data/com.termux/files/home/cloudflare-ddns/config.json

pkg install cronie termux-services python
sv-enable crond
crontab /data/data/com.termux/files/home/music-server/crontab
```
