#!/bin/bash


while [[ -z $username ]]
do
read -p "Enter the user name : " user
done

echo "Validating $username"
if [ `grep -c $username /etc/passwd` -eq 0 ]
then
   echo
   echo "ERROR : PLEASE ENTER A VALID USERNAME."
   echo "Exiting ..."
   exit
else

add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
apt install qbittorrent-nox
qbittorrent-nox
adduser --system --group qbittorrent-nox
adduser $username qbittorrent-nox

echo "[Unit]
Description=qBittorrent Command Line Client
After=network.target

[Service]
#Do not change to "simple"
Type=forking
User=qbittorrent-nox
Group=qbittorrent-nox
UMask=007
ExecStart=/usr/bin/qbittorrent-nox -d --webui-port=8080
Restart=on-failure

[Install]
WantedBy=multi-user.target
" >> /etc/systemd/system/qbittorrent-nox.service
systemctl start qbittorrent-nox
systemctl daemon-reload
systemctl enable qbittorrent-nox
systemctl status qbittorrent-nox
fi