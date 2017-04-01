#! /bin/bash
$image=$1
$command=$2
curl -sSL https://get.docker.com/ | sh
#echo "DOCKER_OPTS=\"-H tcp://127.0.0.1:4243 -H unix:///var/run/docker.sock --mtu=1450  --dns 8.8.8.8 --experimental=true\"" >/etc/default/docker
docker run -d $command $image
