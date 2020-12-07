#!/bin/bash -ev
# TravisCI Autodeploy to Kubernetes Script

# Install kubernetes cli and add to path
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl



