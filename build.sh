#!/bin/bash
echo "Committing changes to GitHub with commit message: $2"
git add .
git commit -m "$2"
git tag -a $1 HEAD -m "$2"
git push

echo "Creating GitHub release"
GH_TOKEN=$(cat ~/Downloads/github-token.txt)
GH_REPO="rhysctf/devopsblog"
GH_API="https://api.github.com/repos/$GH_REPO"
TAG_NAME="$1"
curl -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: token $GH_TOKEN" \
    -d "{\"tag_name\": \"$TAG_NAME\"}" \
    "$GH_API/releases"

echo "Building new Docker Image with Image Tag: $1"
docker build -t rhys7homas/devopsblog-image:$1 .
docker push rhys7homas/devopsblog-image:$1

echo "Done"

# ./build.sh v1.0.0 "this is the github commit code"