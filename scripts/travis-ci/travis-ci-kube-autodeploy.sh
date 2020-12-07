#!/bin/bash -ev
# TravisCI Autodeploy to Kubernetes Script

# Generate latest docker image name
full_docker_image_name="$DOCKER_IMAGE_NAME:$(git rev-parse --short=6 HEAD)"

# Update kube deployment files with new container version
find ./kube -type f | xargs sed -i "s/CONTAINER_VERSION/$full_docker_image_name/g"

# Install kubernetes cli and add to path
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
