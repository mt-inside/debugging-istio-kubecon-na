source 00-common.sh

kubectl delete -f istio-$ISTIO_VERSION/samples/bookinfo/platform/kube/rbac/productpage-policy.yaml # * -> productpage
kubectl delete -f istio-$ISTIO_VERSION/samples/bookinfo/platform/kube/rbac/details-reviews-policy.yaml # productpage -> { details, reviews }
kubectl delete -f istio-$ISTIO_VERSION/samples/bookinfo/platform/kube/rbac/ratings-policy.yaml # reviews -> ratings

istioctl experimental wait --for delete ServiceRoleBinding bind-ratings
