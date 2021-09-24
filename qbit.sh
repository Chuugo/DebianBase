#!/bin/bash

read -p "Enter the user name : " username
echo "Validating $username"

if [ `grep -c $username /etc/passwd` -eq 0 ]
then
   echo "ERROR : PLEASE ENTER A VALID USERNAME."
   echo "EXITING"
   exit
else

add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
apt install qbittorrent-nox -y
qbittorrent-nox & disown
adduser --system --group qbittorrent-nox
adduser $username qbittorrent-nox

   if [ -f /etc/systemd/system/qbittorrent-nox.service ]
   then
      rm /etc/systemd/system/qbittorrent-nox.service
      echo "[Unit]
      Description=qBittorrent Command Line Client
      After=network.target

      [Service]
      #Do not change to "simple"
      Type=forking
      User=qbittorrent-nox
      Group=qbittorrent-nox
      UMask=007
      ExecStart=/usr/bin/qbittorrent-nox -d --webui-port=4369
      Restart=on-failure

      [Install]
      WantedBy=multi-user.target
      " >> /etc/systemd/system/qbittorrent-nox.service

   else
      echo "[Unit]
      Description=qBittorrent Command Line Client
      After=network.target

      [Service]
      #Do not change to "simple"
      Type=forking
      User=qbittorrent-nox
      Group=qbittorrent-nox
      UMask=007
      ExecStart=/usr/bin/qbittorrent-nox -d --webui-port=4369
      Restart=on-failure

      [Install]
      WantedBy=multi-user.target
      " >> /etc/systemd/system/qbittorrent-nox.service
   fi
systemctl start qbittorrent-nox
systemctl daemon-reload
systemctl enable qbittorrent-nox
systemctl status qbittorrent-nox
systemctl reload qbittorrent-nox
fi
