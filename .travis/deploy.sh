#!/bin/bash -xe

HELMSMAN="helmsman -no-banner -no-ns -no-fancy"

# Store version of current deployed statefulset
kubectl config use-context staging
OLD_VERSION=$(kubectl -n staging get sts swarm-staging -o jsonpath="{.metadata.resourceVersion}")

# Perform updates
for e in *.yaml
do
  ENV="${e%.*}" # Remove the extension 'staging.yaml' becomes 'staging'
  kubectl config use-context "$ENV" && $HELMSMAN --apply -f "$ENV.yaml"
done

# Check if the statefulset was updated
kubectl config use-context staging
NEW_VERSION=$(kubectl -n staging get sts swarm-staging -o jsonpath="{.metadata.resourceVersion}")

if [ "$OLD_VERSION" != "$NEW_VERSION" ]; then
  kubectl -n staging delete pods -l release=swarm-staging,app=swarm,component=swarm
fi
