Setup and config for a subsonic (via Navidrone) music server running on a Raspberry Pi. Automatically removes songs with ☆☆☆☆★ reviews and uses cloudflare for dynamic DNS updates.

# File Locations
```
cp avidrome.toml /var/lib/navidrome
cp navidrome.service /etc/systemd/system
```

# DDNS
Setup [https://github.com/adrienbrignon/cloudflare-ddns]
(what about https://github.com/timothymiller/cloudflare-ddns)
```
cp davidhampgonsalves.com.yml cloudflare-ddns/zones
```

# Music Location
/mnt/dietpi_userdata/

# Navidrone
sudo systemctl start navidrome.service
sudo systemctl status navidrome.service

## Update
https://www.navidrome.org/docs/installation/pre-built-binaries/

```
wget https://github.com/navidrome/navidrome/releases/download/v0.40.0/navidrome_0.40.0_Linux_armv7.tar.gz -O Navidrome.tar.gz

sudo tar -xvzf Navidrome.tar.gz -C /opt/navidrome/
sudo chown -R root:root /opt/navidrome

sudo systemctl restart navidrome.service
```
