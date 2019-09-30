[ "$0" != "$BASH_SOURCE" ] || { echo "Error: script must be sourced, not run"; exit 1; }

source 00-versions.sh

set -x

kubectl apply -f istio-$ISTIO_VERSION/samples/bookinfo/networking/bookinfo-gateway.yaml
kubectl get gateway
kubectl -n istio-system port-forward $(kubectl -n istio-system get pod -l app=istio-ingressgateway -o jsonpath='{.items[0].metadata.name}') 8080:80 > /dev/null &
export GATEWAY_URL=localhost:8080
set +x

echo open http://$GATEWAY_URL/productpage
