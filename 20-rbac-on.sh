source 00-common.sh

# NB: THIS NEEDS mTLS ON. OTHERWISE ALL CONFIG IS ACCEPTED AND EVERYTHING
# LOOKS GOOD BUT ENVOY'S RBAC FILTER DOESN'T GET THE AUTHN PRINCIPAL WITH
# THE REQUEST SO IT JUST DENIES EVERYTHING.

# See:
# - https://istio.io/docs/tasks/security/authn-policy/
# - https://istio.io/docs/concepts/security/#authorization
# - https://istio.io/help/ops/security/debugging-authorization/

# Turn RBAC on
kubectl apply -f istio-$ISTIO_VERSION/samples/bookinfo/platform/kube/rbac/rbac-config-ON.yaml
