source 00-common.sh

helm template \
    --name istio \
    --namespace istio-system \
    --values istio-$ISTIO_VERSION/install/kubernetes/helm/istio/values.yaml \
    --set global.proxy.accessLogFile="/dev/stdout" \
    -x templates/configmap.yaml \
    istio-$ISTIO_VERSION/install/kubernetes/helm/istio \
    | kubectl apply -f - | grep --color -E "configured$|created$|$"
