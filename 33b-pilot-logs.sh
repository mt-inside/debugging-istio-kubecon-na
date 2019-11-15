source 00-common.sh

kubectl logs -n istio-system -l app=pilot -c discovery -f
