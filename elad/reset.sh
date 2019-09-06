#!/bin/sh -ex
export NAMESPACE=janos

kubectl delete namespace $NAMESPACE || true
kubectl create namespace $NAMESPACE
kubectl -n $NAMESPACE apply -f tiller.rbac.yaml
helm init --service-account tiller --tiller-namespace $NAMESPACE

sleep 15

helm --tiller-namespace=$NAMESPACE --namespace=$NAMESPACE --name=swarm install ethersphere/swarm-private -f swarm.yaml
helm --tiller-namespace=$NAMESPACE --namespace=$NAMESPACE --name=smoke install ethersphere/smoke -f smoke.yaml
