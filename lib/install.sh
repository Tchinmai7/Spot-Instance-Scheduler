#!/bin/bash
curl -sSL https://get.docker.com/ | sh
apt-get update
apt-get install -y criu
mkdir -p /etc/systemd/system/docker.service.d
printf '[Service]\nExecStart=\nExecStart=/usr/bin/dockerd -H fd:// --experimental=true' > /etc/systemd/system/docker.service.d/docker.conf
systemctl daemon-reload
systemctl restart docker.service
docker pull shriram2301/counter 
docker create -p 80:80 --name nginx_counter shriram2301/counter
docker start nginx_counter
