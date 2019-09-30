source 00-common.sh

set -x

istioctl dashboard envoy $(kubectl get pod -l app=details -o jsonpath='{.items[0].metadata.name}')
