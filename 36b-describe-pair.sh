source 00-common.sh

istioctl x describe pod $(kubectl get pod -l app=productpage -o jsonpath='{.items[0].metadata.name}')

echo
echo
echo

istioctl x describe service details
