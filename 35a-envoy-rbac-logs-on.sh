source 00-common.sh

set -x

kubectl exec $(kubectl get pods -l app=details -o jsonpath='{.items[0].metadata.name}') -c istio-proxy -- pilot-agent request POST 'logging?rbac=debug'
