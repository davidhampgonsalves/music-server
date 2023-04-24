Setup for my personal [https://github.com/navidrome/navidrome](Navidrome) based music streaming server running on a non-rooted Samsung Galaxy S7 using [https://termux.dev/en/](Termux). 

## features
* Uses [https://wiki.termux.com/wiki/Termux:Boot](Termux:Boot) & [https://wiki.termux.com/wiki/Termux-services](Termux-services) to automatically start everything on boot.
* Automatically removes songs with ☆☆☆☆★ reviews.
* Uses Cloudflare for dynamic DNS updates.

## Add Music
I transfer music using SFTP after converting to OPUS. The S7 only has about 20GB of usable storage and this makes a big difference.

IOS doesn't do OPUS except in a CAF and Navidrome doesn't like the CAF container.
```
mkdir mp3
find . -iname '*.mp3' -exec bash -c 'F=$(cat /dev/urandom | gtr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1); ffmpeg -i "{}" -codec:a libmp3lame -qscale:a 6 "../mp3/$F.mp3"' \;
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
ssh root@192.168.2.89 -p 8022
```
pkg add git wget neovim -y
git clone https://github.com/davidhampgonsalves/music-server.git
```

### Navidrome
Termux can't run binaries, even if they are built for arm64. As such we will build navidrome.
```
pkg add golang taglib build-essential
git clone https://github.com/navidrome/navidrome 8b93962 
// might want to checkout a specfic commit that matches a release
mkdir music
cd navidrome
cp ../music-server/navidrome.toml ./
make setup

// building the navidrone UI OOM's on my Samsung Galaxy S7
// so build it on a PC (via cd ui ; npm install ; npm run build) and 
// then transfer the ui/build contents to the same folder under navidrome via sftp
// This has to be done before `go build` or else it won't be included in binary

go mod download
go build

// setup sshd and navidrome as services
pkg install termux-services
// restart so that daemon starts
mkdir -p $PREFIX/var/service/navidrome/log
ln -s $PREFIX/share/termux-services/svlogger $PREFIX/var/service/navidrome/log/run
chmod u+x $PREFIX/var/service/navidrome/run

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
```

### Termux Boot
```
mkdir ./termux/boot
mv music-server/boot/start-services .termux/boot/
chmod ugo+x .termux/boot/start-services
```

# DDNS
python venv creation(happening in start-sync.sh) was hanging so after installing the requirements from start-sync.sh I commented out everything except `cd ... ; python ...`.
```
git clone https://github.com/timothymiller/cloudflare-ddns.git
chmod +x /data/data/com.termux/files/home/cloudflare-ddns/start-sync.sh
chmod +x /data/data/com.termux/files/home/music-server/remove-starred-tracks.sh
ln -s /data/data/com.termux/files/home/music-server/cloudflare-ddns.config.json /data/data/com.termux/files/home/cloudflare-ddns/config.json

pkg install cronie termux-services python sqlite
sv-enable crond
crontab /data/data/com.termux/files/home/music-server/crontab
```