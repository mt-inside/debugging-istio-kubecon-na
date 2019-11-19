source 00-common.sh

kubectl apply -f istio-$ISTIO_VERSION/install/kubernetes/namespace.yaml

helm template istio-$ISTIO_VERSION/install/kubernetes/helm/istio-init --namespace istio-system | kubectl apply -f -

set +x

declare crd_count
while true
do
    crd_count=$(echo $(kubectl get crds | grep 'istio.io' | wc -l))
    echo "CRDs: $crd_count"
    if [ $crd_count -eq 23 ]
    then
        echo "OK."
        break
    else
        echo "Waiting..."
    fi
    sleep 1
done

set -x

# We use values.yaml here to be representative.
#
# values-istio-demo.yaml automatically does some stuff that we want to make a point of turning on manually:
# * Enables envoy access logs.
# * Enabled mixer telemetry logging, by setting `mixer.adapters.stdio.enabled=true`, which makes handler and rule # `stdio`, plus instance `accesslog`
#
# We could also for values.yaml with a few minor things from values-istio-demo.yaml:
# * Sensible requests for things, especially Pilot
$HELM template \
    --namespace istio-system \
    --values istio-$ISTIO_VERSION/install/kubernetes/helm/istio/values-istio-demo.yaml \
    istio-$ISTIO_VERSION/install/kubernetes/helm/istio \
    | kubectl apply -f -

kubectl label namespace default --overwrite=true istio-injection=enabled

set +x

declare phase
while true
do
    phase=$(kubectl get -n istio-system pod -l app=sidecarInjectorWebhook -o jsonpath='{.items[0].status.phase}')
    echo "Webhook phase: $phase"
    if [[ $phase == "Running" ]]
    then
	echo "OK."
	break
    else
	echo "Waiting..."
    fi
    sleep 1
done

set -x

watch -n1 kubectl get pods -n istio-system
