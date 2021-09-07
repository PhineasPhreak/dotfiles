#!/bin/bash
# The apt repository contains packages for both x86-64 and arm64.


# Import GPG key for apt-key
echo '[*] Install Linux Package Manager Repositories'
echo '[*] Install GPG key for APT'
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
echo '[+] Import GPG key OK'

# Install sublime text deb repositories with name 'sublime-text.list'
echo '[*] STABLE is the channel used'
bash -c 'echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list'
echo '[+] STABLE is the channel used'

# Install apt in HTTPS and package sublime-text
echo '[*] Ensure apt is set up to work with https sources'
echo '[*] Installation of "Sublime text" and "Sublime Merge"'
sudo apt-get update
sudo apt-get install -y apt-transport-https sublime-text sublime-merge
echo '[+] Ensure apt is set up to work with https sources and sublime-text'
echo '[+] Installation OK'

