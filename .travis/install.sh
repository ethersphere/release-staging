#!/bin/bash

BIN_DIR=$(pwd)/bin/
mkdir "$BIN_DIR"
export PATH=$BIN_DIR:$PATH

# Install kubectl
wget -q "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
chmod +x ./kubectl
mv ./kubectl "$BIN_DIR/kubectl"

# Install helm
wget -q "https://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz"
tar xzfv "helm-v${HELM_VERSION}-linux-amd64.tar.gz"
mv "$(pwd)/linux-amd64/helm" "$BIN_DIR/helm"

# Install helmsman
curl -L https://github.com/Praqma/helmsman/releases/download/v1.7.3-rc/helmsman_1.7.3-rc_linux_amd64.tar.gz | tar zx --directory "$BIN_DIR"

# Decrypt secrets
mkdir "$HOME/.kube"
openssl aes-256-cbc -K "$encrypted_12c8071d2874_key" -iv "$encrypted_12c8071d2874_iv" -in .travis/secrets.tar.enc -out "$HOME/.kube/secrets.tar" -d
tar xvf "$HOME/.kube/secrets.tar" --directory "$HOME/.kube"

# Configure kubectl
kubectl config set-cluster default --server="$KUBECONFIG_URL" --certificate-authority="$HOME/.kube/kubernetes.ca.crt"

kubectl config set-credentials staging --token="$(cat $HOME/.kube/staging.token)" &> /dev/null
kubectl config set-context staging --cluster=default --user=staging --namespace=staging

# Configure helm
helm init --client-only
helm plugin install https://github.com/databus23/helm-diff --version master
