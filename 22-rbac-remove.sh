source 00-common.sh

set -x

kubectl delete -f istio-$ISTIO_VERSION/samples/bookinfo/platform/kube/rbac/productpage-policy.yaml # * -> productpage
kubectl delete -f istio-$ISTIO_VERSION/samples/bookinfo/platform/kube/rbac/details-reviews-policy.yaml # productpage -> { details, reviews }
kubectl delete -f istio-$ISTIO_VERSION/samples/bookinfo/platform/kube/rbac/ratings-policy.yaml # reviews -> ratings
