#!/bin/bash -ev
# TravisCI Docker Build and Publish Script

# Ensure all required environment variables are present
if [ -z "$DOCKER_IMAGE_NAME_APP" ] || \
    [ -z "$DOCKER_IMAGE_NAME_SIDEKIQ" ] || \
    [ -z "$DOCKER_USERNAME" ] || \
    [ -z "$DOCKER_PASSWORD" ]; then
    >&2 echo 'Required variable unset, docker build and deploy failed'
    exit 1
fi

branch_head_commit=$(git rev-parse --short=6 HEAD)
full_docker_image_name_app="$DOCKER_IMAGE_NAME_APP:$branch_head_commit"
full_docker_image_name_sidekiq="$DOCKER_IMAGE_NAME_SIDEKIQ:$branch_head_commit"

echo : "
Travis-CI docker build and publish script
Repo: $TRAVIS_REPO_SLUG
Images: 
  - $full_docker_image_name_app
  - $full_docker_image_name_sidekiq
"

# Clean repo
git clean

# Build app image
docker build -t "$full_docker_image_name_app" .

# Build worker image
docker build -t "$full_docker_image_name_sidekiq" ./sidekiq.Dockerfile

# Login to docker
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin >/dev/null 2>&1

# Publish to dockerhub
docker push "$full_docker_image_name_app"
docker push "$full_docker_image_name_sidekiq"