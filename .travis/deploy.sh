#!/bin/bash -xe

HELMSMAN="helmsman -no-banner -no-ns -no-fancy"

# Store version of current deployed statefulsets
kubectl config use-context staging
PUBLIC_OLD_VERSION=$(kubectl -n staging get sts swarm-staging -o jsonpath="{.metadata.resourceVersion}")
PRIVATE_OLD_VERSION=$(kubectl -n staging get sts swarm-private -o jsonpath="{.metadata.resourceVersion}")

# Perform updates
for e in *.yaml
do
  ENV="${e%.*}" # Remove the extension 'staging.yaml' becomes 'staging'
  kubectl config use-context "$ENV" && $HELMSMAN --apply -f "$ENV.yaml"
done

# Check if the statefulsets were updated
kubectl config use-context staging
PUBLIC_NEW_VERSION=$(kubectl -n staging get sts swarm-staging -o jsonpath="{.metadata.resourceVersion}")
PRIVATE_NEW_VERSION=$(kubectl -n staging get sts swarm-private -o jsonpath="{.metadata.resourceVersion}")

if [ "$PUBLIC_OLD_VERSION" != "$PUBLIC_NEW_VERSION" ]; then
  kubectl -n staging delete pods -l release=swarm-staging,app=swarm,component=swarm
fi

if [ "$PRIVATE_OLD_VERSION" != "$PRIVATE_NEW_VERSION" ]; then
  kubectl -n staging delete pods -l release=swarm-private,app=swarm-private,component=swarm
fi
