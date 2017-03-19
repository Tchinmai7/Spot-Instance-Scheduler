#! /bin/bash
$image=$1
$command=$2
curl -sSL https://get.docker.com/ | sh
docker run $command $image
