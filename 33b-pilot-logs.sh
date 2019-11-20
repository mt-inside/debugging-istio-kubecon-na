source 00-common.sh

#kubectl logs -n istio-system -l app=pilot -c discovery -f | highlight 'generated policy for role: details-reviews-viewer'
kubectl logs -n istio-system -l app=pilot -c discovery -f | highlight 'LDS: PUSH for node:details'
