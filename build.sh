#!/bin/bash
echo "building new docker image with image tag: $1"
docker build -t rhys7homas/devopsblog-image:$1 .
docker push rhys7homas/devopsblog-image:$1
echo "done"
