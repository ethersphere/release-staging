#!/bin/bash -xe

HELMSMAN="helmsman -no-banner -no-ns -no-fancy"

for e in *.yaml
do
  ENV="${e%.*}" # Remove the extension 'staging.yaml' becomes 'staging'
  kubectl config use-context "$ENV" && $HELMSMAN -show-diff -suppress-diff-secrets -f "$ENV.yaml"
done
