source 00-common.sh

set -x

kind create cluster --image kindest/node:$KUBERNETES_VERSION

kubectl get nodes
