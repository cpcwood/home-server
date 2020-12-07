#!/bin/bash -ev
# TravisCI Docker Build and Publish Script

# Ensure all required environment variables are present
if [ -z "$DOCKER_IMAGE_NAME" ] || \
    [ -z "$DOCKER_USERNAME" ] || \
    [ -z "$DOCKER_PASSWORD" ]; then
    >&2 echo 'Required variable unset, docker build and deploy failed'
    exit 1
fi

branch_head_commit=$(git rev-parse --short=6 HEAD)
full_docker_image_name="$DOCKER_IMAGE_NAME:$branch_head_commit"

echo : "
Travis-ci docker build and publish script
Repo: $TRAVIS_REPO_SLUG
Image: $full_docker_image_name
"

# Clean repo
git clean

# Build image
docker build -t "$full_docker_image_name" .

# Login to docker
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin >/dev/null 2>&1

# Publish to dockerhub
docker push "$full_docker_image_name"