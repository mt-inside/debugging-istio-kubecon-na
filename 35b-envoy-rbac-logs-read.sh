source 00-common.sh

kubectl logs -l app=details -c istio-proxy -f | highlight 'istio_authn'
