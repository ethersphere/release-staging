# Swarm staging deployments

[![Build Status](https://travis-ci.org/ethersphere/release-staging.svg?branch=master)](https://travis-ci.org/ethersphere/release-staging)

This repository contains all the definitions for the staging releases used by the swarm team.

We're using [helmsman](https://github.com/Praqma/helmsman) to manage the deployments to our kubernetes cluster. You can learn more about helmsman's [desired state specification](https://github.com/Praqma/helmsman/blob/master/docs/desired_state_specification.md).

## Continuous Delivery

Merges on master will trigger deployments via [Travis](.travis.yml).

## Secret management

The following environment variables have to be encrypted:

```sh
$ travis encrypt KUBECONFIG_URL=https://address-to-your-k8s-cluster
```


Additionally there is also a `secrets.tar` file that needs to be encrypted. This one should contain the following:

- `kubernetes.ca.crt` - CA certificate to validate the TLS connection against the K8S API defined in $KUBECONFIG_URL
- `{NAMESPACE}.token` - Service account token that will be used on each namespace, normally it's the one that can be used with Tiller .e.g `staging.token`

```sh
$ tar cvf secrets.tar kubernetes.ca.crt staging.token ....
$ travis encrypt-file secrets.tar
$ mv secrets.tar.enc .travis/secrets.tar.enc
```
