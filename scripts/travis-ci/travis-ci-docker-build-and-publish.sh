#!/bin/bash -ev
# TravisCI Docker Build and Publish Script

# Ensure all required environment variables are present
if [ -z "$DOCKER_IMAGE_NAME" ] || \
    [ -z "$DOCKER_USERNAME" ] || \
    [ -z "$DOCKER_PASSWORD" ] || \
    [ -z "$GRECAPTCHA_SITE_KEY" ]; then
    >&2 echo 'Required variable unset, docker build and deploy failed'
    exit 1
fi

git_commit=$(git rev-parse --short=8 HEAD)
docker_image_name_base="$DOCKER_USERNAME/$DOCKER_IMAGE_NAME-base"
docker_image_name_app="$DOCKER_USERNAME/$DOCKER_IMAGE_NAME-app"
docker_image_name_worker_dependencies="$DOCKER_USERNAME/$DOCKER_IMAGE_NAME-worker-dependencies"
docker_image_name_worker="$DOCKER_USERNAME/$DOCKER_IMAGE_NAME-worker"

echo : "
Travis-CI docker build and publish script
Repo: $TRAVIS_REPO_SLUG
Images:
  - $docker_image_name_base
  - $docker_image_name_app
  - $docker_image_name_worker_dependencies
  - $docker_image_name_worker
"

# Pull latest base image
echo "Pulling latest $docker_image_name_base"
docker pull "$docker_image_name_base" || true

# Build base image
echo "Building Image: $docker_image_name_base"
docker build \
    --cache-from "$docker_image_name_base" \
    -t "$docker_image_name_base:$git_commit" \
    -t "$docker_image_name_base:latest" \
    --build-arg grecaptcha_site_key=$GRECAPTCHA_SITE_KEY \
    -f ./base.Dockerfile \
    .

# Pull latest app image
echo "Pulling latest $docker_image_name_app"
docker pull "$docker_image_name_app" || true

# Build app image
echo "Building Image: $docker_image_name_app"
docker build \
    --cache-from "$docker_image_name_app" \
    -t "$docker_image_name_app:$git_commit" \
    -t "$docker_image_name_app:latest" \
    .


# Pull latest worker dependencies image
echo "Pulling latest $docker_image_name_worker_dependencies" 
docker pull "$docker_image_name_worker_dependencies" || true

# Build worker image
echo "Building Image: $docker_image_name_worker_dependencies"
docker build \
    --cache-from "$docker_image_name_worker_dependencies" \
    -t "$docker_image_name_worker_dependencies:$git_commit" \
    -t "$docker_image_name_worker_dependencies:latest" \
    -f ./worker-dependencies.Dockerfile \
    .

# Pull latest worker image
echo "Pulling latest $docker_image_name_worker" 
docker pull "$docker_image_name_worker" || true

# Build worker image
echo "Building Image: $docker_image_name_worker"
docker build \
    --cache-from "$docker_image_name_worker" \
    -t "$docker_image_name_worker:$git_commit" \
    -t "$docker_image_name_worker:latest" \
    -f ./worker.Dockerfile \
    .

# Login to docker
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin >/dev/null 2>&1

# Publish to dockerhub
echo 'Pushing images to docker'
docker push "$docker_image_name_base"
docker push "$docker_image_name_app"
docker push "$docker_image_name_worker_dependencies"
docker push "$docker_image_name_worker"