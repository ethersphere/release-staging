# Staging deployments

This repository contains all the definitions for the staging releases used by the swarm team.

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
