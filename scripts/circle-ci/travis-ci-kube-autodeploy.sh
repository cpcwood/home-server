#!/bin/bash -ev
# TravisCI Autodeploy to Kubernetes Script

# Ensure all required environment variables are present
if [ -z "$KUBERNETES_CLUSTER_CERTIFICATE" ] || \
    [ -z "$KUBERNETES_SERVER" ] || \
    [ -z "$KUBERNETES_SERVICE_ACC_TOKEN" ]; then
    >&2 echo 'Required variable unset, docker build and deploy failed'
    exit 1
fi

# Generate latest docker image name
container_version=$(git rev-parse --short=8 HEAD)

echo : "
Travis-CI autodeploy to kubernetes script
Repo: $TRAVIS_REPO_SLUG
Image Version: $container_version
"

# Update kube deployment files with new container version
echo 'Updating config files in ./kube with current container version'
find ./kube/ -type f | xargs sed -i "s/CONTAINER_VERSION/$container_version/g"

# Install kubernetes cli and add to path
echo 'Installing kubectl'
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Create cerifiticate file
echo 'Creating cluster certificate'
echo "$KUBERNETES_CLUSTER_CERTIFICATE" | base64 --decode > cert.crt

# Apply updated kubernetes application config
echo 'Applying updated application config'
kubectl --kubeconfig=/dev/null \
  --certificate-authority=cert.crt \
  --server=$KUBERNETES_SERVER \
  --token=$KUBERNETES_SERVICE_ACC_TOKEN \
  apply -Rf ./kube/app/