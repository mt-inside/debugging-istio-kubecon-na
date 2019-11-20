source 00-common.sh

$HELM template \
    --namespace istio-system \
    --values istio-$ISTIO_VERSION/install/kubernetes/helm/istio/values-istio-demo.yaml \
    --set global.proxy.accessLogFile="/dev/stdout" \
    -x templates/configmap.yaml \
    istio-$ISTIO_VERSION/install/kubernetes/helm/istio \
    | kubectl apply -f - | grep --color -E "configured$|created$|$"
