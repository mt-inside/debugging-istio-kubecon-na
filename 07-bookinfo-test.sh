source 00-common.sh

curl -o /dev/null -s -w "%{http_code}\n" http://${GATEWAY_URL}/productpage

echo now open http://${GATEWAY_URL}/productpage
