#!/bin/bash

# basics: https://www.makeuseof.com/complete-guide-to-privacy-on-steam-deck/

# optional: enable Secure Boot: 
## https://github.com/ryanrudolfoba/SecureBootForSteamDeck

# optional: Browsing: privacy-by-default for firefox: https://github.com/arkenfox/user.js
wget https://github.com/arkenfox/user.js/blob/master/user.js -P ~/Downloads
echo //////
echo "// privacy-as-default for firefox: place the user.js-file (downloads-folder) in the following subfolder of /home/deck/.var/app/org.mozilla.firefox/.mozilla/firefox/"
grep 'Path=' ~/.mozilla/firefox/profiles.ini | sed s/^Path=//
echo //////
## mv ./user.js /home/deck/.var/app/org.mozilla.firefox/.mozilla/firefox/$FOLDER/

# optional: install pi-hole locally: https://github.com/pi-hole/pi-hole/#one-step-automated-install
## curl -sSL https://install.pi-hole.net | bash

sudo steamos-readonly disable
sudo rm -R /home/deck/.cache/*

#remove unneeded services
sudo systemctl disable systemd-timesyncd
sudo systemctl stop systemd-timesyncd
sudo systemctl disable avahi-daemon
sudo systemctl stop  avahi-daemon
sudo systemctl disable avahi-daemon.socket
sudo systemctl stop avahi-daemon.socket 

# basics: wlan-advertisement, strengthen privacy
sudo mkdir /etc/NetworkManager/conf.d
sudo cp ./wifi_backend.conf /etc/NetworkManager/conf.d

# basics: dns-queries, dot
# also see: https://wiki.archlinux.org/title/Systemd-resolved#DNS_over_TLS
sudo mkdir /etc/systemd/resolved.conf.d 
sudo cp ./dns_over_tls.conf /etc/systemd/resolved.conf.d

sudo systemctl restart systemd-resolved
sudo systemctl enable systemd-resolved
sudo systemctl status systemd-resolved

# basics: firewall, strengthen
# tbd > Suggestions?
# needed: steam 80, 443, UDP 27015-27050, TCP 27015-27050; epic: 80, 433, 443, 3478, 3479, 5060, 5062, 5222, 6250, 12000-65

# basics: local blocklists -- /etc/hosts
sudo sh ./hosts_update.sh

# install packages
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman-key --populate holo
sudo pacman-key --refresh-keys
#sudo pacman -Syu
sudo pacman -Fy
sudo pacman -S tcpdump firejail gamemode fakeroot kvantum --overwrite '*'

#firejail
sudo firecfg
firecfg --list
#sudo firecfg --clean

#optional: opensnitch (personal firewall)
#sudo pacman -S opensnitch
#systemctl enable opensnitchd
#systemctl start opensnitchd
