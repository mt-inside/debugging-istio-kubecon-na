source 00-common.sh

# TODO: cause rather than effect
echo "FILTER: http.response.code==403"

kubectl sniff $(kubectl get pods -l app=details -o jsonpath='{.items[0].metadata.name}') -c details
