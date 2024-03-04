#!/bin/bash
echo "building new docker image with image tag: $1"
docker build . devopsblog-image:$1
docker push devopsblog-image:$1
echo "done"
