source 00-common.sh

set -x

kubectl logs -l app=details -c istio-proxy -f
