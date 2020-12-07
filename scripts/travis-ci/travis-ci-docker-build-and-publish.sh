#!/bin/bash -ev
# TravisCI Docker Build and Publish Script

# Ensure all required environment variables are present
if [ -z "$DOCKER_IMAGE_NAME" ] || \
    [ -z "$DOCKER_USERNAME" ] || \
    [ -z "$DOCKER_PASSWORD" ]; then
    >&2 echo 'Required variable unset, automerging failed'
    exit 1
fi

echo : "
Travis-ci docker build and publishscript
Repo: $TRAVIS_REPO_SLUG
Image: $DOCKER_IMAGE_NAME
"

# Clean repo
git clean

# Build image
docker build -t "$DOCKER_IMAGE_NAME" .

# Login to docker
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin >/dev/null 2>&1

# Publish to dockerhub
docker push "$DOCKER_IMAGE_NAME"