#! /bin/bash

#Script inicial con mis configuraciones básicas. Se usa cuando el sistema ha sido reformateado

sudo apt-get purge -y simple-scan thunderbird pidgin hexchat brasero rhythmbox bluez-cups cups cups-client
sudo apt-get -y autoremove

﻿sudo apt-get update
sudo apt-get upgrade -y
reboot

#Repositorios a añadir
#Libreoffice, flux, ozmartian-apps, kodi, teejee2008, steam
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - 
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:kdenlive/kdenlive-stable ppa:teejee2008/ppa ppa:team-xbmc/ppa ppa:atareao/atareao ppa:nathan-renniewaldock/flux
wget -c "http://download.bitdefender.com/SMB/Workstation_Security_and_Management/BitDefender_Antivirus_Scanner_for_Unices/Unix/Current/EN_FR_BR_RO/Linux/BitDefender-Antivirus-Scanner-7.7-1-linux-amd64.deb.run"
sudo echo "deb http://download.bitdefender.com/repos/deb/ bitdefender non-free" >> /etc/apt/sources.list
sudo apt-get install apt-transport-https ca-certificates -y
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo echo deb https://apt.dockerproject.org/repo ubuntu-xenial main >> /etc/apt/sources.list.d/docker.list
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80       --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'

#Compatibilidad de Packet Tracer con sistemas de 64 bits
sudo dpkg --add-architecture i386

sudo apt-get update

sudo apt install linux-image-generic linux-image-extra-virtual
sudo apt-get install docker-engine 
sudo sh BitDefender-Antivirus-Scanner-7.7-1-linux-amd64.deb.run 
sudo apt-get install -y kdenlive google-chrome-stable kodi conky-manager bitdefender-scanner-gui firefox-locale-es eclipse texmaker texlive-full ttf-mscorefonts-installer g++ pluma mysql-client-core-5.7 libreoffice-l10n-es gparted dvdauthor frei0r-plugins touchpad-indicator nodejs-legacy nodejs pip3 mint-meta-mate mint-artwork-gnome mint-themes fluxgui aptik alien

sudo pip3 install --upgrade pip

sudo chmod -R 0777 /home/jesus/.cache/pip/
sudo -H pip3 install Django==1.8

#Encender demonio Docker
sudo service docker stop
sudo nohup docker daemon -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock &
sudo docker info
sudo usermod -aG docker jesus

#Librerias Packet Tracer
sudo apt-get install -y libnss3-1d:i386 libqt4-qt3support:i386 libssl1.0.0:i386 libqtwebkit4:i386 libqt4-scripttools:i386

