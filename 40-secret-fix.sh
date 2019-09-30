source 00-common.sh

set -x

# Receiving envoys should accept only mTLS
# Not stictly necessary, as the default is PERMISSIVE
kubectl patch MeshPolicy default --type json -p '[{"op": "replace", "path": "/spec/peers/0/mtls", "value": {}}]' > /dev/null

# Bookinfo services send mTLS
kubectl apply -f istio-$ISTIO_VERSION/samples/bookinfo/networking/destination-rule-all-mtls.yaml > /dev/null

echo 🤫
