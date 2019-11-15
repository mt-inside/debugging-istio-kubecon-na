source 00-common.sh

kubectl apply -f istio-$ISTIO_VERSION/samples/bookinfo/platform/kube/rbac/rbac-config-on-permissive.yaml

# The samples directory includes a handler, instance, and rule which log
# permissive RBAC info to stdout:
kubectl apply -f istio-$ISTIO_VERSION/samples/bookinfo/platform/kube/rbac/rbac-permissive-telemetry.yaml

# The "default" telemetry logging also has those permissive RBAC fields
# (modulo defaulting to "" rather than "none").
# It would be on by default with `values-istio-demo.yaml`, or
# we could turn it on thus:
# $HELM template \
#     --name istio \
#     --namespace istio-system \
#     --values istio-$ISTIO_VERSION/install/kubernetes/helm/istio/values.yaml \
#     --set mixer.adapters.stdio.enabled=true \
#     -x charts/mixer/templates/config.yaml \
#     istio-$ISTIO_VERSION/install/kubernetes/helm/istio \
#     | kubectl apply -f - | grep --color -E "configured$|created$|$"
