#!/bin/bash
echo "Committing changes to GitHub with commit message: $2"
git add .
git commit -m "$2"
git tag -a $1 HEAD
git push

echo "Building new Docker Image with Image Tag: $1"
docker build -t rhys7homas/devopsblog-image:$1 .
docker push rhys7homas/devopsblog-image:$1

echo "Done"

# ./build.sh v1.0.0 "this is the github commit code"