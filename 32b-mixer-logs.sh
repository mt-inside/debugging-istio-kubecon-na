source 00-common.sh

set -x

# Have to grep, cause the log is very verbose, including traffic heading to the `telemetry` service itself
# "samples/rbac-permissive-telemetry.yaml" logging uses the field name "destination", and defaults empty permissiveResponseCodes to ""
kubectl logs -n istio-system -l istio-mixer-type=telemetry -c mixer -f | grep \"destination\":\"details\" | grep --color -E "permissiveResponseCode|responseCode"

# "default" logging uses the field name "destinationApp", and defaults empty permissiveResponseCodes to "none"
