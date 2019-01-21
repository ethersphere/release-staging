#!/bin/bash -xe

NAMESPACE=staging

# Add repo
helm repo add ethersphere https://raw.githubusercontent.com/ethersphere/helm-charts-artifacts/master/
helm repo update

# Aliases
HELM_INSTALL="helm install --tiller-namespace=$NAMESPACE --namespace=$NAMESPACE"
HELM_UPGRADE="helm upgrade --tiller-namespace=$NAMESPACE"


ALREADY_INSTALLED=$(helm list --tiller-namespace=$NAMESPACE | wc -l | awk '{print $1}')
if [ "$ALREADY_INSTALLED" -ne 0 ]; then
  $HELM_UPGRADE swarm ethersphere/swarm --values swarm-staging.yaml
else
  $HELM_INSTALL --name=swarm ethersphere/swarm --values swarm-staging.yaml
fi
