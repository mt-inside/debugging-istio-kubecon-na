source 00-common.sh

istioctl dashboard controlz -n istio-system $(kubectl -n istio-system get pod -l app=pilot -o jsonpath='{.items[0].metadata.name}')
