#!/bin/bash -ev
# TravisCI Docker Build and Publish Script

# Build image
docker build -t "$DOCKER_IMAGE_NAME" .

# Login to docker
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin >/dev/null 2>&1

# Publish to dockerhub
docker push "$DOCKER_IMAGE_NAME"