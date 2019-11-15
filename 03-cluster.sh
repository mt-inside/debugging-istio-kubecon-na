source 00-common.sh

kind create cluster --image kindest/node:$KUBERNETES_VERSION

kubectl config use-context kind-kind

kubectl get nodes
