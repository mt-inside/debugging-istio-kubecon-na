source 00-common.sh

set -x

kubectl delete -f istio-$ISTIO_VERSION/samples/bookinfo/networking/destination-rule-all-mtls.yaml

kubectl patch MeshPolicy default --type json -p '[{"op": "replace", "path": "/spec/peers/0/mtls", "value": {"mode": "PERMISSIVE"}}]'
