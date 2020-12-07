#!/bin/bash -ev
# TravisCI Docker Build and Publish Script

# Ensure all required environment variables are present
if [ -z "$DOCKER_IMAGE_NAME_APP" ] || \
    [ -z "$DOCKER_IMAGE_NAME_WORKER" ] || \
    [ -z "$DOCKER_USERNAME" ] || \
    [ -z "$DOCKER_PASSWORD" ] || \
    [ -z "$GRECAPTCHA_SITE_KEY" ]; then
    >&2 echo 'Required variable unset, docker build and deploy failed'
    exit 1
fi

branch_head_commit=$(git rev-parse --short=8 HEAD)
full_docker_image_name_app="$DOCKER_IMAGE_NAME_APP:$branch_head_commit"
full_docker_image_name_worker="$DOCKER_IMAGE_NAME_WORKER:$branch_head_commit"

echo : "
Travis-CI docker build and publish script
Repo: $TRAVIS_REPO_SLUG
Images:
  - $full_docker_image_name_app
  - $full_docker_image_name_worker
"

# Pull latest app image
echo "Pulling latest $DOCKER_IMAGE_NAME_APP"
docker pull "$DOCKER_IMAGE_NAME_APP"

# Build app image
echo "Building Image: $full_docker_image_name_app"
docker build -t "$full_docker_image_name_app" \
    --build-arg grecaptcha_site_key=$GRECAPTCHA_SITE_KEY \
    .

# Pull latest worker image
echo "Pulling latest $DOCKER_IMAGE_NAME_WORKER"
docker pull "$DOCKER_IMAGE_NAME_WORKER"

# Build worker image
echo "Building Image: $full_docker_image_name_worker"
docker build -t "$full_docker_image_name_worker" \
    --build-arg grecaptcha_site_key=$GRECAPTCHA_SITE_KEY \
    -f ./sidekiq.Dockerfile \
    .

# Login to docker
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin >/dev/null 2>&1

# Publish to dockerhub
docker push "$full_docker_image_name_app"
docker push "$full_docker_image_name_worker"