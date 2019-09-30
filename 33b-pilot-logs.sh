source 00-common.sh

set -x

kubectl logs -n istio-system -l app=pilot -c discovery -f
