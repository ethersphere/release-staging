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

# Decrypt secrets
mkdir "$HOME/.kube"
openssl aes-256-cbc -K "$encrypted_12c8071d2874_key" -iv "$encrypted_12c8071d2874_iv" -in .travis/secrets.tar.enc -out "$HOME/.kube/secrets.tar" -d
tar xvf "$HOME/.kube/secrets.tar" --directory "$HOME/.kube"

# Configure kubectl
kubectl config set-credentials default --token="$(cat $HOME/.kube/token)" &> /dev/null
kubectl config set-cluster default --server="$KUBECONFIG_URL" --certificate-authority="$HOME/.kube/kubernetes.ca.crt"
kubectl config set-context default --cluster=default --user=default --namespace="$KUBECONFIG_NAMESPACE"
kubectl config use-context default

# Configure helm
helm init --client-only
