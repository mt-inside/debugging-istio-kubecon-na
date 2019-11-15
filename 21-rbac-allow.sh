source 00-common.sh

kubectl apply -f istio-$ISTIO_VERSION/samples/bookinfo/platform/kube/rbac/productpage-policy.yaml # * -> productpage
kubectl apply -f istio-$ISTIO_VERSION/samples/bookinfo/platform/kube/rbac/details-reviews-policy.yaml # productpage -> { details, reviews }
kubectl apply -f istio-$ISTIO_VERSION/samples/bookinfo/platform/kube/rbac/ratings-policy.yaml # reviews -> ratings

istioctl experimental wait ServiceRoleBinding bind-ratings
